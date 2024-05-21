require "test_helper"

class PostTest < ActiveSupport::TestCase

  test 'should not be valid without body' do
    post = posts(:post_one)
    post.body = nil

    assert_not post.valid?
  end

  test 'should not be valid without user_id' do
    post = posts(:post_one)
    post.user_id = nil

    assert_not post.valid?
  end

  test 'created_at and updated_at should not be nil' do
    user = users(:john)
    post = Post.create(body: 'test@example.com', user: user)
    assert_not_nil post.created_at
    assert_not_nil post.updated_at
  end


  test 'should validate presence of body' do
    post = posts(:post_one)
    post.body = nil

    assert_not post.valid?
  end

  test 'should validate maximum length of body' do
    post = posts(:post_one)
    post.body = 'a' * 501

    assert_not post.valid?
  end

  test 'post image size must be under limit' do
    post = Post.new
    big_file = StringIO.new('a' * (5.megabytes + 1))
    post.post_image.attach(io: big_file, filename: 'big_file.jpg', content_type: 'image/jpg')

    assert_not post.valid?
    assert_includes post.errors[:post_image], 'is too large (max is 5MB)'
    assert_not post.post_image.attached?
  end

  test 'post image must be an image file' do
    post = Post.new
    non_image_file = StringIO.new('This is not an image file')
    post.post_image.attach(io: non_image_file, filename: 'non_image_file.txt', content_type: 'text/plain')

    assert_not post.valid?
    assert_includes post.errors[:post_image], 'must be an image file'
    assert_not post.post_image.attached?
  end

  test 'should have many comments' do
    post = posts(:post_one)
    assert_difference('post.comments.count') do
      post.comments.create(body: 'This is a comment', user: users(:john))
    end
  end

  test 'should destroy associated comments when destroyed' do
    post = posts(:post_one)
    post.comments.destroy_all
    post.comments.create(body: 'This is a comment', user: users(:john))
    assert_difference('Comment.count', -1) do
      post.destroy
    end
  end

  test 'should have many post_likes' do
    post = posts(:post_one)
    assert_difference('post.post_likes.count') do
      post.post_likes.create(user: users(:john))
    end
  end

  test 'should destroy associated post_likes when destroyed' do
    post = posts(:post_one)
    post.post_likes.destroy_all
    post.post_likes.create(user: users(:john))
    assert_difference('PostLike.count', -1) do
      post.destroy
    end
  end

  test 'should have many likers through post_likes' do
    post = posts(:post_one)
    liker = users(:john)
    post.post_likes.create(user: liker)
    assert_includes post.likers, liker
  end

end

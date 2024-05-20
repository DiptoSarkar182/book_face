require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user john' do
    users(:john).valid?
    assert users(:john).valid?
  end

  test 'valid user jane' do
    users(:jane).valid?
    assert users(:jane).valid?
  end

  test 'valid user jay' do
    users(:jay).valid?
    assert users(:jay).valid?
  end

  test 'invalid without first_name' do
    john = users(:john)
    john.first_name = nil
    assert_not john.valid?
  end

  test 'invalid without last_name' do
    john = users(:john)
    john.last_name = nil
    assert_not john.valid?
  end

  test 'first_name and last_name minimum length is 2' do
    user = User.new(first_name: 'J', last_name: 'D')
    assert_not user.valid?
  end

  test 'email should not be nil' do
    user = User.new(email: nil)
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test 'email should default to empty string' do
    user = User.new
    assert_equal user.email, ""
  end

  test 'email should be unique' do
    john = users(:john)
    duplicate_user = User.new(email: john.email, first_name: 'Jane', last_name: 'Doe', password: 'password', password_confirmation: 'password')
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], 'has already been taken'
  end

  test 'encrypted password should not be nil' do
    user = User.new(password: nil)
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test 'encrypted password should match' do
    password = 'password'
    user = User.create(email: 'test@example.com', first_name: 'Jane', last_name: 'Doe', password: password, password_confirmation: password)
    assert user.valid_password?(password)
  end


  test 'encrypted password should be empty string' do
    user = User.new
    assert_equal user.encrypted_password, ""
  end

  test 'reset_password_token should be unique' do
    john = users(:john)
    john.reset_password_token = "token"
    john.save!

    duplicate_token = User.new(email: 'test@example.com', first_name: 'Jane', last_name: 'Doe', password: 'password', password_confirmation: 'password', reset_password_token: 'token')

    assert_raises(ActiveRecord::RecordNotUnique) do
      duplicate_token.save!
    end
  end

  test 'created_at and updated_at should not be nil' do
    user = User.create(email: 'test@example.com', first_name: 'Jane', last_name: 'Doe', password: 'password', password_confirmation: 'password')
    assert_not_nil user.created_at
    assert_not_nil user.updated_at
  end

  test 'birthday must be at least one year in the past' do
    user = User.new(birthday: 6.months.ago.to_date)
    assert_not user.valid?
  end

  test 'bio maximum length is 500' do
    user = User.new(bio: 'a' * 501)
    assert_not user.valid?
  end

  test 'location maximum length is 100' do
    user = User.new(location: 'a' * 101)
    assert_not user.valid?
  end

  test 'profile image size must be under limit' do
    user = User.new
    big_file = StringIO.new('a' * (5.megabytes + 1))
    user.profile_image.attach(io: big_file, filename: 'big_file.jpg', content_type: 'image/jpg')

    assert_not user.valid?
    assert_includes user.errors[:profile_image], 'is too large (max is 5MB)'
    assert_not user.profile_image.attached?
  end

  test 'profile image must be an image file' do
    user = User.new
    non_image_file = StringIO.new('This is not an image file')
    user.profile_image.attach(io: non_image_file, filename: 'non_image_file.txt', content_type: 'text/plain')

    assert_not user.valid?
    assert_includes user.errors[:profile_image], 'must be an image file'
    assert_not user.profile_image.attached?
  end

  test 'should delete associated posts when user is destroyed' do
    user = users(:john)
    post = user.posts.create!(body: 'Test Body')

    assert_difference 'Post.count', -user.posts.count do
      user.destroy
    end
  end

  test 'should delete associated comments when user is destroyed' do
    user = users(:john)
    post = user.posts.create!(body: 'Test post')
    comment = post.comments.create!(body: 'Test comment', user: user)

    assert_difference 'Comment.count', -user.comments.count do
      user.destroy
    end
  end

  test 'should delete associated post likes when user is destroyed' do
    user = users(:john)
    post = user.posts.create!(body: 'Test post')
    post_like = post.post_likes.create!(user: user)

    initial_post_like_count = user.post_likes.count
    user.destroy
    final_post_like_count = PostLike.count

    assert_equal initial_post_like_count - 1, final_post_like_count
  end

  test 'should delete associated sent friend requests when user is destroyed' do
    sender = users(:john)
    receiver = users(:jane)
    friend_request = sender.sent_friend_requests.create!(receiver: receiver)

    assert_difference 'FriendRequest.count', -sender.sent_friend_requests.reload.count do
      sender.destroy
    end
  end

  test 'should delete associated received friend requests when user is destroyed' do
    sender = users(:john)
    receiver = users(:jane)
    friend_request = sender.sent_friend_requests.create!(receiver: receiver)

    assert_difference 'FriendRequest.count', -receiver.received_friend_requests.reload.count do
      receiver.destroy
    end
  end

  test 'should delete associated friend lists when user is destroyed' do
    user = users(:john)
    friend = users(:jane)
    friend_list = user.friend_lists.create!(friend: friend)

    assert_difference 'FriendList.count', -user.friend_lists.reload.count do
      user.destroy
    end
  end


end
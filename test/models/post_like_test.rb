require "test_helper"

class PostLikeTest < ActiveSupport::TestCase
  def setup
    @post = posts(:post_one)
    @user = users(:jane)
    @post_like = PostLike.new(post: @post, user: @user)
  end

  test "should be valid" do
    assert @post_like.valid?
  end

  test "should require a post_id" do
    @post_like.post_id = nil
    assert_not @post_like.valid?
  end

  test "should require a user_id" do
    @post_like.user_id = nil
    assert_not @post_like.valid?
  end

  test "should have timestamps" do
    @post_like.save
    assert_not_nil @post_like.created_at
    assert_not_nil @post_like.updated_at
  end

  test "should belong to user" do
    assert @post_like.respond_to?(:user)
  end

  test "should belong to post" do
    assert @post_like.respond_to?(:post)
  end

end

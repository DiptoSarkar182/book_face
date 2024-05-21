require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment_one = comments(:one)
    @comment_two = comments(:two)
  end

  test "should be valid" do
    assert @comment_one.valid?
    assert @comment_two.valid?
  end

  test "body should be present" do
    @comment_one.body = ""
    assert_not @comment_one.valid?
    @comment_two.body = "   "
    assert_not @comment_two.valid?
  end

  test "should require a user_id" do
    @comment_one.user_id = nil
    assert_not @comment_one.valid?
    @comment_two.user_id = nil
    assert_not @comment_two.valid?
  end

  test "should require a post_id" do
    @comment_one.post_id = nil
    assert_not @comment_one.valid?
    @comment_two.post_id = nil
    assert_not @comment_two.valid?
  end

  test "should have timestamps" do
    @comment_one.save
    assert_not_nil @comment_one.created_at
    assert_not_nil @comment_one.updated_at
    @comment_two.save
    assert_not_nil @comment_two.created_at
    assert_not_nil @comment_two.updated_at
  end

  test "should belong to user" do
    assert @comment_one.respond_to?(:user)
    assert @comment_two.respond_to?(:user)
  end

  test "should belong to post" do
    assert @comment_one.respond_to?(:post)
    assert @comment_two.respond_to?(:post)
  end

  test "body should be present and not too long" do
    @comment_one.body = ""
    assert_not @comment_one.valid?
    @comment_two.body = "a" * 1001
    assert_not @comment_two.valid?
  end

end

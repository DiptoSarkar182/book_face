require "test_helper"

class FriendListTest < ActiveSupport::TestCase
  def setup
    @friendship_one = friend_lists(:friendship_one)
  end

  test "should be valid" do
    assert @friendship_one.valid?
  end

  test "should require a user_id" do
    @friendship_one.user_id = nil
    assert_not @friendship_one.valid?
  end

  test "should require a friend_id" do
    @friendship_one.friend_id = nil
    assert_not @friendship_one.valid?
  end

  test "should have timestamps" do
    @friendship_one.save
    assert_not_nil @friendship_one.created_at
    assert_not_nil @friendship_one.updated_at
  end

  test "should belong to user" do
    assert @friendship_one.respond_to?(:user)
  end

  test "should belong to friend" do
    assert @friendship_one.respond_to?(:friend)
  end


end

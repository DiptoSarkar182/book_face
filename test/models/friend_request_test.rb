require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @request_one = friend_requests(:request_one)
  end

  test "should be valid" do
    assert @request_one.valid?
  end

  test "should require a sender_id" do
    @request_one.sender_id = nil
    assert_not @request_one.valid?
  end

  test "should require a receiver_id" do
    @request_one.receiver_id = nil
    assert_not @request_one.valid?
  end

  test "should have default status as pending" do
    assert_equal "pending", @request_one.status
  end

  test "should have timestamps" do
    @request_one.save
    assert_not_nil @request_one.created_at
    assert_not_nil @request_one.updated_at
  end

  test "should belong to sender" do
    assert @request_one.respond_to?(:sender)
  end

  test "should belong to receiver" do
    assert @request_one.respond_to?(:receiver)
  end


end

require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    @message_one = messages(:message_one)
    @message_two = messages(:message_two)
  end

  test "should be valid" do
    assert @message_one.valid?
    assert @message_two.valid?
  end

  test "content should be present" do
    @message_one.content = ""
    assert_not @message_one.valid?
    @message_two.content = "   "
    assert_not @message_two.valid?
  end

  test "should belong to sender" do
    assert @message_one.respond_to?(:sender)
    assert @message_two.respond_to?(:sender)
  end

  test "should belong to receiver" do
    assert @message_one.respond_to?(:receiver)
    assert @message_two.respond_to?(:receiver)
  end


end

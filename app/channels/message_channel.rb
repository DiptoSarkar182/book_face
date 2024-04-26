class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_#{params[:conversation]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("message_#{params[:conversation]}", data)
  end
end

class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.receiver_id = params[:inbox_id]

    if @message.save
      #ActionCable.server.broadcast("message_#{conversation_identifier}", @message.as_json(include: :sender).merge(conversation: conversation_identifier))
      ActionCable.server.broadcast("message_#{conversation_identifier}",
                                   @message.as_json(include: :sender).merge(
                                     conversation: conversation_identifier,
                                     sender_name: @message.sender.full_name,
                                     sender_id: @message.sender.id,
                                     timestamp: @message.created_at.strftime('%B %d, %Y %I:%M %p')
                                   )
      )
      redirect_to inbox_path(params[:inbox_id])
    else
      @messages = Message.where(sender_id: current_user.id, receiver_id: params[:inbox_id])
                         .or(Message.where(sender_id: params[:inbox_id], receiver_id: current_user.id))
      render 'inbox/show'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def conversation_identifier
    [current_user.id.to_s, params[:inbox_id]].sort.join("_")
  end
end

class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.receiver_id = params[:inbox_id]

    if @message.save
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
end

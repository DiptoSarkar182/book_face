class InboxController < ApplicationController
  before_action :redirect_to_index, only: :show
  def index
    @inbox_friends = current_user.friends
  end

  def show
    @chatting_with = User.find(params[:id])
    @messages = Message.where(sender_id: current_user.id, receiver_id: params[:id])
                       .or(Message.where(sender_id: params[:id], receiver_id: current_user.id))
    @message = Message.new
  end

  def redirect_to_index
    if request.get? && !request.headers['Turbo-Frame']
      redirect_to inbox_index_path
    end
  end
end

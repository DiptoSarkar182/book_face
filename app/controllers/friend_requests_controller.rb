class FriendRequestsController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
  end
  def create
    @friend_request = FriendRequest.new(sender: current_user, receiver_id: params[:receiver_id])
    respond_to do |format|
      if @friend_request.save
        format.html {redirect_to friend_requests_path, notice: "Friend request sent!"}
      else
        format.html {redirect_to friend_requests_path, alert: "Friend request could not be sent."}
      end
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
    respond_to do |format|
      format.html { redirect_to friend_requests_path, notice: "Friend request cancelled." }
    end
  end
  def accept
    friend_request = current_user.received_friend_requests.find_by(sender_id: params[:id])
    if friend_request
      FriendList.create!(user: current_user, friend: friend_request.sender)
      FriendList.create!(user: friend_request.sender, friend: current_user)
      friend_request.destroy
      redirect_to notifications_path, notice: "Friend request accepted."
    else
      redirect_to notifications_path, alert: "Friend request not found."
    end
  end
  def reject
    friend_request = current_user.received_friend_requests.find_by(sender_id: params[:id])
    if friend_request
      friend_request.destroy
      redirect_to notifications_path, notice: "Friend request rejected."
    else
      redirect_to notifications_path, alert: "Friend request not found."
    end
  end
end

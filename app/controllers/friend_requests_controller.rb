class FriendRequestsController < ApplicationController

  # /friend_requests
  def index
    redirect_to root_path, alert: "Search users by the search box."
  end

  # /friend_requests
  def create
    @friend_request = FriendRequest.new(sender: current_user, receiver_id: params[:receiver_id])
    if @friend_request.save
      render partial: "add_cancel_friend", locals: { user: @friend_request.receiver }
    else
      redirect_to friend_requests_path, alert: "Friend request could not be sent."
    end
  end

  # /friend_requests/:id
  def destroy
    @friend_request = FriendRequest.find(params[:id])
    user = @friend_request.receiver
    @friend_request.destroy
    render partial: "add_cancel_friend", locals: { user: user }
  end

  # /friend_requests/:id/accept
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

  # /friend_requests/:id/reject
  def reject
    friend_request = current_user.received_friend_requests.find_by(sender_id: params[:id])
    if friend_request
      friend_request.destroy
      redirect_to notifications_path, notice: "Friend request rejected."
    else
      redirect_to notifications_path, alert: "Friend request not found."
    end
  end

  # /friend_requests/search_friend
  def search_friend
    search_term = params[:name]
    @name_search_results = User.where("first_name ILIKE :search OR last_name ILIKE :search OR CONCAT(first_name, ' ', last_name) ILIKE :search", search: "%#{search_term}%")
    @users = User.where.not(id: current_user.id)
                 .where.not(id: current_user.friends.select(:id))
    if @name_search_results.empty?
      flash[:search_message] = "User not found."
    else
      flash[:search_message] = "User found."
    end
    render 'friend_requests/index'
  end
end

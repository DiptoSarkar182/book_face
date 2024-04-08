class NotificationsController < ApplicationController
  def index
    @friend_requests = current_user.received_friend_requests.where(status: 'pending')
  end
end

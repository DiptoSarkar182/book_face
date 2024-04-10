class FriendsListController < ApplicationController
  def index
    @friends = current_user.friends
  end
  def destroy
    friend = User.find(params[:id])
    current_user.friends.destroy(friend)
    friend.friends.destroy(current_user)
    redirect_to friends_list_path, notice: 'Friend was successfully removed.'
  end
end

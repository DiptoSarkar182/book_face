class FriendsListController < ApplicationController
  def index
    @friends = current_user.friends
    @users = User.where.not(id: current_user.id)
                 .where.not(id: current_user.friends.select(:id))
                 .order("RANDOM()")
                 .limit(10)
  end
  def destroy
    friend = User.find(params[:id])
    current_user.friends.destroy(friend)
    friend.friends.destroy(current_user)
    redirect_to friends_list_path, notice: 'Friend was successfully removed.'
  end
end

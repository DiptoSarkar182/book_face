class UsersProfileController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.update(user_additional_info_params)
        format.html {redirect_to users_profile_path(@user), notice: "Profile updated successfully!"}
      else
        format.html {render 'edit', status: :unprocessable_entity }
      end
    end
  end

  private
  def user_additional_info_params
    params.require(:user).permit(:profile_image, :bio, :gender, :location, :birthday)
  end
end

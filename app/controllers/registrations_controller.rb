class RegistrationsController < Devise::RegistrationsController

  def create
    super do |user|
      if user.persisted?
        UserMailer.with(user: @user).welcome_email.deliver_later
      end
    end
  end

  def update
    super do |resource|
      if resource.previous_changes.keys.include?('encrypted_password')
        Devise::Mailer.password_change(resource).deliver_later
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :password, :password_confirmation,
                                 :current_password)
  end
end
class PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.find_or_initialize_with_errors(resource_class.reset_password_keys, resource_params, :not_found)
    if resource.provider == 'google_oauth2'
      set_flash_message!(:alert, :cannot_reset_password)
      redirect_to new_password_path(resource_name) and return
    end
    super
  end
end
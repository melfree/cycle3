class Users::SessionsController < Devise::SessionsController
  # This overwrites the Devise function's redirect as a bug fix.
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    #respond_with resource, location: after_sign_in_path_for(resource)
    redirect_to dashboard_url
  end
end
class Users::SessionsController < Devise::SessionsController
  # This overwrites the Devise function's redirect as a bug fix.
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?

    # Action cable requirement
    cookies.signed[:user_id] = resource.id

    redirect_to dashboard_url
  end
end
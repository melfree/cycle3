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
  
  def destroy
    # Action cable requirement
    cookies.delete :user_name
    
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    respond_to_on_destroy
  end
end
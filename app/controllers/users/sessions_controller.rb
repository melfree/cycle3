class Users::SessionsController < Devise::SessionsController
  # This overwrites the Devise function's redirect as a bug fix.
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in)
    sign_in(resource_name, resource)

    # Action cable requirement
    cookies.signed[:user_id] = resource.id

    redirect_to dashboard_url
  end
  
  def destroy
    # Action cable requirement
    cookies.delete :user_name
    
    signed_out = sign_out
    set_flash_message :notice, :signed_out if signed_out
    respond_to_on_destroy
  end
end
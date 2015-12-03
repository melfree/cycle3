class Users::RegistrationsController < Devise::RegistrationsController
  # This overwrites the Devise function's redirect as a bug fix.
  def create
    build_resource(sign_up_params)
    if resource.save
      set_flash_message :notice, :signed_up if is_flashing_format?
      sign_up(resource_name, resource)
       
      # Action cable requirement
      cookies.signed[:user_id] = resource.id
      
      redirect_to guest_url
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:alert] = resource.errors.full_messages.first
      render :new
    end
  end
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if update_resource(resource, account_update_params)
      set_flash_message :notice, :updated
      sign_in resource_name, resource, bypass: true
    else
      clean_up_passwords resource
    end
    redirect_to edit_user_registration_url
  end
  
  private
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
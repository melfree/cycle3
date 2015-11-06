class Users::RegistrationsController < Devise::RegistrationsController
  # This overwrites the Devise function's redirect as a bug fix.
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      set_flash_message :notice, :signed_up if is_flashing_format?
      sign_up(resource_name, resource)
       
      # Action cable requirement
      cookies.signed[:user_id] = resource.id
      
      redirect_to dashboard_url
    else
      clean_up_passwords resource
      set_minimum_password_length
      #respond_with resource
      render :new
    end
  end
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
    else
      clean_up_passwords resource
    end
    render :edit
  end
  
  private
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
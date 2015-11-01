class Users::RegistrationsController < Devise::RegistrationsController
  # This overwrites the Devise function's redirect as a bug fix.
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource)
        redirect_to dashboard_url
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        #respond_with resource, location: after_inactive_sign_up_path_for(resource)
        redirect_to root_url
      end
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
end
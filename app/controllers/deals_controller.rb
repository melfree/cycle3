class DealsController < ApplicationController
  
  def index
  end
  
  def edit_current_deal
    current_user.current_deal.update_attributes!(current_deal_params)
  end

  private
  def current_deal_params
    # Either update :buyer_status_code or :seller_status code,
    # Depending on who the current user is.
    params.required(:deal).permit(current_user.deal_status_attribute)
  end
end

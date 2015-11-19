class DealsController < ApplicationController
  
  def index
  end
  
  def edit_current_deal
    current_user.current_deal.update_attributes!(current_deal_params)
  end

  def make_deal
    # Manually matches the current user to the user who owns the :id that was passed in.
    current_user.manual_match_user(User.find(params[:id]))
  end

  private
  def current_deal_params
    # Either update :buyer_status_code or :seller_status code,
    # Depending on who the current user is.
    params.required(:deal).permit(current_user.deal_status_attribute)
  end

end

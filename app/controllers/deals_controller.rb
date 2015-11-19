class DealsController < ApplicationController
  
  def index
  end
  
  def edit_current_deal
    deal = current_user.current_deal
    # seller_status_code is used as a placeholder;
    # depending on what current user is, we may be updating buyer_status_code instead:
    status_code = params[:deal][:seller_status_code]
    if current_user.is_buyer
      deal.buyer_status_code = status_code
    else
      deal.seller_status_code = status_code
    end
    deal.save!
  end

  def make_deal
    # Manually matches the current user to the user who owns the :id that was passed in.
    current_user.manual_match_user(User.find(params[:id]))
  end
end

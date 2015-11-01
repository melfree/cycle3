class DealsController < ApplicationController
  before_action :set_deal

  def create
    if @deal.is_sale
      @deal.seller_id = current_user.id
    else
      @deal.buyer_id = current_user.id
    end
    @deal.save!
  end

  private
    def set_deal
      @deal = Deal.new(params.require(:deal).permit(*deal_params))
    end
end

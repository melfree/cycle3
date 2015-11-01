class DealsController < ApplicationController
  before_action :set_deal

  def create
    @deal.save!
  end

  private
    def set_deal
      @deal = params.require(:deal).permit(*deal_params)
    end
end

class DealsController < ApplicationController
  before_action :set_deal

  def create
    #@deal.save! = Deal.create! content: params[:comment][:content], message: @message, user: current_user
  end

  private
    def set_message
      @deal = params.require(:deal).permit(:dinex)
    end
end

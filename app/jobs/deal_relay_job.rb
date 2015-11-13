class DealRelayJob < ApplicationJob
  def perform(deal)
    # A seller should get updates for their deal only if they are still associated with the deal.
    # After that, the seller should not be updated about the deal.
    if deal.seller.current_deal_id == deal.id
      ActionCable.server.broadcast "deals_#{deal.seller.id}", {
        html: HomeController.render(partial: 'deals/match', locals: { user: deal.seller })
      }
    end
    
    if deal.buyer.current_deal_id == deal.id
      ActionCable.server.broadcast "deals_#{deal.buyer.id}", {
        html: HomeController.render(partial: 'deals/match', locals: { user: deal.buyer })
      }
    end
  end
end
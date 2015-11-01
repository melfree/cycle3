class DealRelayJob < ApplicationJob
  def perform(deal)
    ActionCable.server.broadcast "home",
      {key_id: deal.id,
       is_deal: true,
       key: 'data-deal-id',
       is_sale: deal.is_sale,
       is_purchase: deal.is_purchase,
       html: DealsController.render(partial: 'deals/deal', locals: { deal: deal })
      }
  end
end
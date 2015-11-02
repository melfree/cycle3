class DealRelayJob < ApplicationJob
  def perform(deal)
    ActionCable.server.broadcast "home",
      {key_id: deal.id,
       is_deal: true,
       key: 'data-deal-id',
       is_sale: deal.is_sale,
       is_purchase: deal.is_purchase,
       is_complete: deal.is_complete,
       html: html(deal)
      }
  end
  
  private
  def html(deal)
    if !deal.is_complete
      DealsController.render(partial: 'deals/deal', locals: { deal: deal })
    else
      # deal is complete, so we'll just be deleting the existing html,
      # so we don't need to render any new html.
      'Placeholder'
    end
  end
end
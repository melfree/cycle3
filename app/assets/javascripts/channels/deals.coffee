$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    # FOR MATCH USER (CENTER OF PAGE)
    App.deal = App.cable.subscriptions.create "DealChannel",
      received: (deal) ->
        # Update the 'matched user' stuff when a user gets a match,
        # or the match's info changes.
        $("#deal_help_block").replaceWith deal.html
        updateHelpBlocks()
        
        # Initialize dropdowns
        $('select').select2
          theme: 'bootstrap'
        
        # Set user_status to 0 if deal ended
        $("#user_status_code").val('0')
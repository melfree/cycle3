$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    # FOR MATCH USER (CENTER OF PAGE)
    App.deal = App.cable.subscriptions.create "DealChannel",
      received: (deal) ->
        # Update the 'matched user' stuff when a user gets a match,
        # or the match's info changes.
        $("#chatroom").replaceWith deal.chatroom_html
        $("#match_user").replaceWith deal.match_user_html
        $.UpdateHelpBlocks()
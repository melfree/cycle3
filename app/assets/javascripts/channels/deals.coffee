$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    # FOR MATCH USER (CENTER OF PAGE)
    App.deal = App.cable.subscriptions.create "DealChannel",
      received: (data) ->
        # Update the 'matched user' stuff when a user gets a match,
        # or the match's info changes.
        $("#chatroom").replaceWith data.chatroom_html
        $("#match_user").replaceWith data.match_user_html
        $("#match_user_status").replaceWith data.match_user_status_html
        
        if data.in_progress
          $("#step_one_container").addClass "hidden"
          $("#step_two_container").removeClass "hidden"
        else
          $("#step_one_container").removeClass "hidden"
          $("#step_two_container").addClass "hidden" 
        
        # Scroll chatroom to bottom
        $("#chatroom").scrollTop($("#chatroom")[0].scrollHeight);
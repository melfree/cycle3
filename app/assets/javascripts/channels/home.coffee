$(document).on "page:change", ->
  if $("body.home.index").length > 0
    
    # FOR MATCH USER (CENTER OF PAGE)
    App.match = App.cable.subscriptions.create "MatchChannel",
      received: (data) ->
        # Update the 'matched user' stuff when a user gets a match,
        # or the match's info changes.
        $("#matched_user_help_block").replaceWith data.html
        $("#find_match_help_block_closed").addClass("hidden")
        @disableSwitches()
      
      disableSwitches: ->
        $("#find_match_help_block_false").removeClass("hidden")
        $('#find_match_help_block_true').addClass("hidden")
        
        firstSwitch = $("#user_find_match")
        secondSwitch = $("#user_find_match_in_progress")
        
        secondSwitch.bootstrapSwitch 'disabled', false
        secondSwitch.bootstrapSwitch 'state', true
        
        firstSwitch.bootstrapSwitch 'disabled', false
        firstSwitch.bootstrapSwitch 'state', false
        firstSwitch.bootstrapSwitch 'disabled', true
        
        
    # FOR LISTINGS AT BOTTOM OF PAGE
    App.home = App.cable.subscriptions.create "HomeChannel",
      received: (data) ->
        # First, it may be a matched user, so replace the matched user info div.
        @replaceMatchedUser(data)
        # Now update the listings at bottom of the page
        s = $("[data-channel='sellers']")
        b = $("[data-channel='buyers']")
        if data.is_unavailable
          @removeItem(data, s.add(b))
        else if data.is_buyer
          @replaceOrAppend(data, b, s)     
        else if data.is_seller
          @replaceOrAppend(data, s, b)
        # Update the google map
        $("#map").html data.html_google_map
        
      replaceMatchedUser: (data) ->
        matchedUserDiv = $("#matched_user_help_block").find("[data-user-id="+data.key_id+"]")
        if data.no_matched_user and matchedUserDiv.length > 0
          # End the most recent match.
          # First, replace the matched user HTML
          $("#matched_user_help_block").replaceWith data.html_matched_user
          # Then notify both users that the match has been closed.
          $("#find_match_help_block_closed").removeClass("hidden")
          # Also make sure "Deal in Progress" is false
          $("#user_find_match_in_progress").bootstrapSwitch 'state', false
        else
          # Update the matched user's info
          matchedUserDiv.replaceWith data.html
        
      removeItem: (data,removeFromCollection) ->
        removeFromCollection.find("[data-user-id="+data.key_id+"]").remove()
        
      replaceOrAppend: (data,addToCollection,removeFromCollection) -> 
        l = addToCollection.find("[data-user-id="+data.key_id+"]")
        if l.length > 0
          # If already in the correct column in the listing, replace it where it is
          l.replaceWith data.html
        else
          # Otherwise, append it the list, and make sure its not in another collection.
          @removeItem data, removeFromCollection
          addToCollection.append data.html
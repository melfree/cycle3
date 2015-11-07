$(document).on "page:change", ->
  if $("body.home.index").length > 0
    
    App.match = App.cable.subscriptions.create "MatchChannel",
      received: (data) ->
        # Update the 'matched user' stuff when a user gets a match.
        $("#user_find_match").bootstrapSwitch 'state', false
        $("#matched_user_help_block").html data.html
        
        
    App.home = App.cable.subscriptions.create "HomeChannel",
      received: (data) ->
        # Update the listings at bottom of the page
        s = $("[data-channel='sellers']")
        b = $("[data-channel='buyers']")
        if data.is_unavailable
          @removeItem(data,s.add(b))
        else if data.is_buyer
          @replaceOrAppend(data,b,s)     
        else if data.is_seller
          @replaceOrAppend(data,s,b)
        # Update the google map
        @updateMap data.html_google_map
      
      updateMap: (html_google_map) ->
        $("#map").html(html_google_map)
      selector: (data) ->
        return "[data-user-id="+data.key_id+"]"
      removeItem: (data,removeFromCollection) ->
        removeFromCollection.find(@selector(data)).remove()  
      replaceOrAppend: (data,addToCollection,removeFromCollection) -> 
        l = addToCollection.find(@selector(data))
        if l.length > 0
          # If already on page, replace it where it is
          l.first().replaceWith(data.html)
        else
          # Otherwise, append it the list, and make sure its not in buyers
          @removeItem(data,removeFromCollection)
          addToCollection.append(data.html)
$(document).on "page:change", ->
  if $("body.users.index").length > 0
        
    # FOR LISTINGS AT BOTTOM OF PAGE
    App.users = App.cable.subscriptions.create "UserChannel",
      received: (user) ->
        # Find and update the user listing
        s = $("[data-channel='sellers']")
        b = $("[data-channel='buyers']")
        if user.is_unavailable
          @removeItem(user, s.add(b))
        else if user.is_buyer
          @replaceOrAppend(user, b, s)     
        else if user.is_seller
          @replaceOrAppend(user, s, b)
          
        # Update the google map
        $("#map").html user.html_google_map
        
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
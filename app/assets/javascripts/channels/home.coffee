App.home = App.cable.subscriptions.create "HomeChannel",
  sellers: -> $("[data-channel='sellers']")
  buyers: -> $("[data-channel='buyers']")

  # This function is the important part
  received: (data) ->
    if data.is_seller
      # If already on page, replace it where it is
      listing = @sellers().find("[data-user-id="+data.user_id+"]")
      if listing.length > 0
        listing.first().replaceWith(data.user)
      # Otherwise, append it the list, and make sure its not in buyers
      else
        @buyers().find("[data-user-id="+data.user_id+"]").remove()
        @sellers().append(data.user)
        
        
    else if data.is_buyer
      listing = @buyers().find("[data-user-id="+data.user_id+"]")
      if listing.length > 0
        listing.first().replaceWith(data.user)
      else
        @sellers().find("[data-user-id="+data.user_id+"]").remove()
        @buyers().append(data.user)
    
    
    else
      @sellers().add(@buyers()).find("[data-user-id="+data.user_id+"]").remove()
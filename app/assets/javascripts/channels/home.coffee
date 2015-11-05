$(document).on "page:change", ->
  if $("body.home.index").length > 0
    
    App.home = App.cable.subscriptions.create "HomeChannel",
      # User selectors
      sellers: -> $("[data-channel='sellers']")
      buyers: -> $("[data-channel='buyers']")
      
      # This function is the important part
      # 'received', by default, receives every message from the stream.
      received: (data) ->
        s = @sellers()
        b = @buyers()
        if data.is_unavailable
          @removeItem(data,s.add(b))
        else if data.is_buyer
          @replaceOrAppend(data,b,s)     
        else if data.is_seller
          @replaceOrAppend(data,s,b)
      
      selector: (data) ->
        return "["+data.key+"="+data.key_id+"]"
      
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
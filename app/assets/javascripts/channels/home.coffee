App.home = App.cable.subscriptions.create "HomeChannel",
  # User selectors
  sellers: -> $("[data-channel='sellers']")
  buyers: -> $("[data-channel='buyers']")
  
  # Deal selectors
  sales: -> $("[data-channel='sales']")
  purchases: -> $("[data-channel='purchases']")

  # This function is the important part
  # 'received', by default, receives every message from the stream.
  received: (data) ->
    if data.is_deal
      @processDeal(data)
    else
      @processUser(data)  
  
  processDeal: (data) ->
    s = @sales()
    p = @purchases()
    if data.is_sale
      @replaceOrAppend(data,s,p)
    else if data.is_purchase
      @replaceOrAppend(data,p,s)
    else
      @removeItem(data,p.add(s))
  
  processUser: (data) ->
    s = @sellers()
    b = @buyers()
    if data.is_seller
      @replaceOrAppend(data,s,b)
    else if data.is_buyer
      @replaceOrAppend(data,b,s)     
    else
      @removeItem(data,s.add(b))
  
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
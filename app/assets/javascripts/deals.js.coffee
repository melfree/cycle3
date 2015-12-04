$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    round = (num) ->
      Math.round(num * 10000) / 10000
      
    ## Location
    # Define the callback, used to process a user's current coords once.
    GeoL = (position) ->
      oldLat = $('#location_latitude').val()
      oldLong = $('#location_longitude').val()
      newLat = round position.coords.latitude
      newLong = round position.coords.longitude
      if (newLat != oldLat or newLong != oldLong) and (newLat and newLong)
        $('#location_latitude').val newLat
        $('#location_longitude').val newLong
        # Submit the hidden fields
        $('#location_latitude').submit()
      $('#geo_help_block_succeeded').removeClass("hidden")
      $("#geo_help_block_init").addClass("hidden")
    
    FindLocation = ->
      $("#geo_help_block_init").removeClass("hidden")
      $("#geo_help_block_succeeded").addClass("hidden")
      $("#geo_help_block_failed").addClass("hidden")
      if (navigator.geolocation)
        navigator.geolocation.getCurrentPosition GeoL
      else
        $("#geo_help_block_failed").removeClass("hidden")
        $("#geo_help_block_init").addClass("hidden")
    
    FindLocation()
    
    # Detect current user's location every 30 seconds.
    window.setInterval FindLocation, 30000
      
    # Clear the message text box when a message is sent
    $("form[data-on-change-message]").on 'ajax:success', ->
      $("#message_content").val("")
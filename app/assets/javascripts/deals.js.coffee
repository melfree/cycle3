$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    # Helper function; round to 5 decimal places
    round = (num) ->
      Math.round(num * 100000) / 100000
    
    ## Location
    # Define the callback, used to process a user's current coords once.
    # Note: This currently only runs on page load.
    # Realistically, a user might move around, which would change their location.
    GeoL = (position) ->
      $('#location_latitude').val round(position.coords.latitude)
      $('#location_longitude').val round(position.coords.longitude)
      $('#geo_help_block_succeeded').removeClass("hidden")
      $("#geo_help_block_init").addClass("hidden")
      # Submit the hidden fields
      $('#location_latitude').submit()
    
    # Detect current user's location.
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition GeoL
    else
      $("#geo_help_block_failed").removeClass("hidden")
      $("#geo_help_block_init").addClass("hidden")

    # Initialize dropdowns
    $('select').select2
      theme: 'bootstrap'
      
    $("form[data-on-change-message]").on 'ajax:success', ->
      $("#message_content").val("")
      
    $("form[data-on-change-deal]").on 'ajax:success', ->
      # Set deal status and user_status to 0 if a deal just ended
      # Model code does this for the database. This JS only updates the view.
      deal_status = $("#deal_seller_status_code")
      if deal_status.select2('val') != '0'
        $("#user_status_code").select2('val','0')
        deal_status.select2('val','0')

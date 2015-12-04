$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    ## Location
    # Define the callback, used to process a user's current coords once.
    # Note: This currently only runs on page load.
    # Realistically, a user might move around, which would change their location.
    GeoL = (position) ->
      $('#location_latitude').val position.coords.latitude
      $('#location_longitude').val position.coords.longitude
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
      
    $("form[data-on-change-message]").on 'ajax:success', ->
      $("#message_content").val("")
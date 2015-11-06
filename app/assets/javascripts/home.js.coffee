$(document).on "page:change", ->
  if $("body.home.index").length > 0
    
    # Helper function; round to 4 decimal places
    round = (num) ->
      Math.round(num * 10000) / 10000
    
    ## Location
    # Define the callback, used to process a user's current coords once.
    GeoL = (position) ->
      lat = round(position.coords.latitude)
      long = round(position.coords.longitude)
      $('#user_latitude').value = lat
      $('#user_longitude').value = long
      $('#geo_help_block_succeeded').removeClass("hidden")
      $("#geo_help_block_init").addClass("hidden")
      # Submit the form
      $('#user_latitude').submit()
    
    # Detect current user's location.
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition GeoL
    else
      $("#geo_help_block_failed").removeClass("hidden")
      $("#geo_help_block_init").addClass("hidden")

    # Initialize cool dropdowns
    $('select').select2
      theme: 'bootstrap'
    
    # Initialize cool Bootstrap switch  
    $("#user_find_match").bootstrapSwitch();
    $("#user_find_match").on 'switchChange.bootstrapSwitch', (event, state) ->
      false_message = $("#find_match_help_block_false")
      true_message = $('#find_match_help_block_true')
      if state
        false_message.addClass("hidden")
        true_message.removeClass("hidden")
      else
        false_message.removeClass("hidden")
        true_message.addClass("hidden")
      $(this).submit()
    
    # On form element change, submit form  
    $("form[data-on-change-submit] :input").change ->
      $(this).submit()
$(document).on "page:change", ->
  if $("body.home.index").length > 0
    
    # Helper function; round to 4 decimal places
    round = (num) ->
      Math.round(num * 10000) / 10000
    
    ## Location
    # Define the callback, used to process a user's current coords once.
    GeoL = (position) ->
      $('#user_latitude').val round(position.coords.latitude)
      $('#user_longitude').val round(position.coords.longitude)
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
    
    # Disable the switch when status = 0
    disableSwitch = ->
      if $("#user_status").val() == '0'
        $("#user_find_match").bootstrapSwitch 'disabled', true
      else
        $("#user_find_match").bootstrapSwitch 'disabled', false
    disableSwitch()
    $("#user_status").change ->
      disableSwitch()
    
    # On form element change, submit form  
    $("form[data-on-change-submit] :input").change ->
      $(this).submit()
$.UpdateHelpBlocks = ->
  # Define updateHelpBlocks method.
  # Alternatively, this stuff could be done using ActionCable instead.
  $(".match_alert").addClass("hidden")
  step_one = $("#step_one_container")
  step_one.addClass("hidden")
  step_two = $("#step_two_container")
  step_two.addClass("hidden")
 
  buyer_status = $("#deal_buyer_status_code").val()
  seller_status = $("#deal_seller_status_code").val()
  deal_status = buyer_status or seller_status
  
  deal_in_progress = $(".matched_user").length > 0
  user_code = $("#user_status_code").val() 

  if deal_status == '1'
    step_one.removeClass("hidden")
    $('#match_help_block_completed').removeClass("hidden")
  else if deal_status == '2'
    step_one.removeClass("hidden")
    $("#match_help_block_cancelled").removeClass("hidden")
  else if user_code == '0'
    step_one.removeClass("hidden")
    $('#match_help_block_unavailable').removeClass("hidden")
  else if !(deal_in_progress)
    step_one.removeClass("hidden")
    $('#match_help_block_searching').removeClass("hidden")
  else
    step_two.removeClass("hidden")
    $('#match_help_block_pending').removeClass("hidden")


$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
    # Helper function; round to 4 decimal places
    round = (num) ->
      Math.round(num * 10000) / 10000
    
    ## Location
    # Define the callback, used to process a user's current coords once.
    # Note: This currently only runs on page load...
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
    
    # On form element change, update help blocks
    $("form[data-on-change-user]").on 'ajax:success', ->
      $.UpdateHelpBlocks()
      
    $("form[data-on-change-message]").on 'ajax:success', ->
      $("#message_content").val("")
      
    $("form[data-on-change-deal]").on 'ajax:success', ->
      # Set deal status and user_status to 0 if a deal just ended
      # Model code does this for the database. This JS only updates the view.
      buyer_status = $("#deal_buyer_status_code").val()
      seller_status = $("#deal_seller_status_code").val()
      deal_status = buyer_status or seller_status
      if deal_status != '0'
        $("#user_status_code").select2('val','0')
      $.UpdateHelpBlocks()
      if deal_status != '0'
        $("#deal_buyer_status_code").select2('val','0')
        $("#deal_seller_status_code").select2('val','0')

    # Update help blocks on page load
    $.UpdateHelpBlocks()
    

$(document).on "page:change", ->
  if $("body.deals.index").length > 0
    
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

    # Initialize dropdowns
    $('select').select2
      theme: 'bootstrap'
    
    # Define updateHelpBlocks method
    unavailable = $('#match_help_block_unavailable')
    searching = $('#match_help_block_searching')
    cancelled = $("#match_help_block_cancelled")
    completed = $('#match_help_block_completed')
    pending = $('#match_help_block_pending')
    all_match_alerts = $(".match_alert")
    updateHelpBlocks = ->
      all_match_alerts.addClass("hidden")
     
      user_status = $("#user_status_code").val()
      
      buyer_status = $("#deal_buyer_status_code").val()
      seller_status = $("#deal_seller_status_code").val()
      deal_status = buyer_status or seller_status
     
      if user_status == '0'
        unavailable.removeClass("hidden")
      else if deal_status == '0'
        pending.removeClass("hidden")
      else if deal_status == '1'
        completed.removeClass("hidden")
      else if deal_status == '2'
        cancelled.removeClass("hidden")
      else
        searching.removeClass("hidden")
          
    # On form element change, submit form  
    $("form[data-on-change-submit] :input").change ->
      updateHelpBlocks()
      $(this).submit()
    
    # Update help blocks on page load
    updateHelpBlocks()
    
    ## Initialize Bootstrap switches, if any
    #switches = $(".bootstrap-switch")
    #switches.bootstrapSwitch()
    #switches.bootstrapSwitch 'onText', "YES"
    #switches.bootstrapSwitch 'offText', "NO"
    #switches.on 'switchChange.bootstrapSwitch', ->
    #  updateHelpBlocks()
    #  $(this).submit()

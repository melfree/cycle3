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
      document.getElementById('user_latitude').value = lat
      document.getElementById('user_longitude').value = long
      document.getElementById('geo_target').innerHTML = "<strong><i class=\"fa fa-check\"></i> Your current location was successfully saved.</strong>"
      # Submit the form
      $('#user_latitude').first().submit()
    
    # Detect user's location.
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition GeoL
      
    else
      document.getElementById("geo_target").innerHTML = "<strong><i class=\"fa fa-times\"></i>We're sorry, geolocation is not supported by this browser.</strong>"

    # Initialize cool dropdowns
    $('select').select2
      theme: 'bootstrap'
    
    # Initialize switch  
    $("#user_find_match").bootstrapSwitch();
    
    # On form element change, submit form  
    $("form[data-on-change-submit] :input").change ->
      $(this).submit()
      #document.getElementById('on_change_target').innerHTML =  "<strong><i class=\"fa fa-check\"></i> Your info changes were successfully saved.</strong>"

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
      document.getElementById('latitude_target').value = lat
      document.getElementById('longitude_target').innerHTML = long
      document.getElementById('user_longitude').value = long
      # Submit the form
      $('#user_latitude').first().submit()
    
    # Detect user's location.
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition GeoL
      
    else
      document.getElementById("geo-help-block").innerHTML = "We're sorry, geolocation is not supported by this browser."

    $('select').select2
      theme: 'bootstrap'
      
    $("form[data-on-change-submit] :input").change ->
      $(this).submit()
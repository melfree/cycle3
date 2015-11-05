$(document).on "page:change", ->
  if $("body.home.index").length > 0
    
    # Define the callback, used to process a user's current coords once.
    GeoL = (position) ->
      document.getElementById('user_latitude').value = position.coords.latitude
      document.getElementById('user_longitude').value = position.coords.longitude
    
    # Detect user's location.
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition GeoL
    else
      document.getElementById("geoWarning").innerHTML = "Geolocation is not supported by this browser."

    $('select').select2
      theme: 'bootstrap'
      width: '200px'
      
    $("form[data-on-change-submit] :input").change ->
      $(this).submit()
$.ready = ->
  # Define the callback, used to process a user's current coords once.
  GeoL = (position) ->
    document.getElementById('user_latitude').value = position.coords.latitude
    document.getElementById('user_longitude').value = position.coords.longitude
  
  # Detect user's location.
  if (navigator.geolocation)
    navigator.geolocation.getCurrentPosition GeoL
  else
    document.getElementById("geoWarning").innerHTML = "Geolocation is not supported by this browser."
  
  # Initialize select2 style dropdowns.
  $('select').select2
    theme: 'bootstrap'
    width: '200px'
  
  # Submit the form with any change to any element.
  # (':input' includes 'input', 'textarea, 'select' elements, etc.)
  $("form[data-on-change-submit] :input").change ->
    console.log("change")
    $(this).submit()

$(document).ready(ready)

# For turbolinks, if we ever turn that back on...
$(document).on('page:load', ready)  
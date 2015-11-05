ready = ->
  $('select').select2
    theme: 'bootstrap'
    width: '200px'
    
  $("form[data-on-change-submit] :input").change ->
    console.log("change")
    $(this).submit()

$(document).ready(ready)

# For turbolinks, if we ever turn that back on...
$(document).on('page:load', ready)  
$(document).on "page:change", ->
  if $("body.deals.index").length > 0
  
    $('select').select2
      theme: 'bootstrap'
      width: '200px'
    
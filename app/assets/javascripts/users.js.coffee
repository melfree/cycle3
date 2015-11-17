$(document).on "page:change", ->
  if $("body.users.index").length > 0
  
    $('select').select2
      theme: 'bootstrap'
      width: '200px'

showBlocks = ->
  alert 'showing '
  console.log("hello");
  return


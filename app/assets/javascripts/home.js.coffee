$(document).on "page:change", ->
  if $("body.home.index").length > 0

    $('select').select2
      theme: 'bootstrap'
      width: '200px'
      
    $("form[data-on-change-submit] :input").change ->
      $(this).submit()
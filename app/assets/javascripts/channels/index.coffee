#= require cable
#= require_self
#= require_tree .

@App = {}
ws_url = "ws://" + window.document.location.host + '/websocket'
App.cable = Cable.createConsumer ws_url

$(document).on "page:change", ->
  current_user = $('meta[name=current-user]')
  if current_user and current_user.attr('id') != ""
    
    # This listener must be active on every page.
    App.home = App.cable.subscriptions.create "HomeChannel",
      received: (data) ->
        # Update current user status bar
        $("#current_user_status").replaceWith data.current_user_status_html
        
        # Update meta information
        # which is used in lieu of Rail's current_user for the 'users' stream.
        $("#meta_container").replaceWith data.meta_html
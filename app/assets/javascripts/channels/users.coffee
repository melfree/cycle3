$(document).on "page:change", ->
  if $("body.users.index").length > 0
        
    # FOR LISTINGS AT BOTTOM OF PAGE
    App.users = App.cable.subscriptions.create "UserChannel",
      received: (data) ->
        if data.statistics_html
          # Answer to StatisticsRelayJob:
          # Update the statistics div
          $("#statistics").replaceWith data.statistics_html
          
        else        
          $("#buyers_container").replaceWith data.buyers_html
          $("#sellers_container").replaceWith data.sellers_html
          
          # Reapply selected javascript filters to new html in List Users
          # by clicking the active filter buttons.
          $("label.active").click()
            
          # Update the google map
          $("#map").html data.html_google_map
window.Helpful =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new Helpful.Routers.Conversations()
    Backbone.history.start(pushState: true)

$(document).ready ->
  Helpful.initialize()

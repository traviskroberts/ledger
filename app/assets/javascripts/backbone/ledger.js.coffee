#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Ledger =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  initialize: ->
    new Ledger.Routers.AppRouter()

    if (!Backbone.history.started)
      Backbone.history.start
        pushState: true

      Backbone.history.started = true

$ ->
  # make sure to route links to backbone
  $('body').on 'click', 'a', (e) ->
    if Backbone.history.started
      e.preventDefault()
      Backbone.history.navigate($(this).attr('href'), true)

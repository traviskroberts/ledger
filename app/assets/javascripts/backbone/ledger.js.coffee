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

  isMobile: ->
    if navigator.userAgent.match(/Android/i) || navigator.userAgent.match(/iPhone|iPad|iPod/i)
      true
    else
      false

$ ->
  # make sure to route links to backbone
  $('body').on 'click', 'a', (e) ->
    if Backbone.history.started && !$(e.target).hasClass('ui-corner-all') # don't hijack jquery-ui autocomplete
      e.preventDefault()
      Backbone.history.navigate($(this).attr('href'), true)

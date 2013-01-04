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

  initialize: (data) ->
    this.accounts = new Ledger.Collections.Accounts(data.accounts)

    new Ledger.Routers.AppRouter({accounts: this.accounts})
    if (!Backbone.history.started)
      Backbone.history.start
        pushState: true

      Backbone.history.started = true

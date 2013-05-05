Ledger.AccountsIndexRoute = Ember.Route.extend
  model: ->
    Ledger.Account.find()

Ledger.AccountRoute = Ember.Route.extend
  model: (params) ->
    Ledger.Account.find(params.url)
  renderTemplate: ->
    @render 'accounts/show'

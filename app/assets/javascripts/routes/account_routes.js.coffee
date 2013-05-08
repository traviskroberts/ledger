Ledger.AccountsIndexRoute = Ember.Route.extend
  model: ->
    Ledger.Account.find()

Ledger.AccountRoute = Ember.Route.extend
  model: (params) ->
    Ledger.Account.find(params.account_id)
  renderTemplate: ->
    @render 'accounts/show'

Ledger.AccountsNewRoute = Ember.Route.extend
  model: ->
    null
  setupController: (controller) ->
    controller.startEditing()

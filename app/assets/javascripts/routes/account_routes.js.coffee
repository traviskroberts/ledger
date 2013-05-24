Ledger.AccountsIndexRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
  model: ->
    if Ledger.Auth.get('signedIn')
      Ledger.Account.find()

Ledger.AccountRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
  model: (params) ->
    if Ledger.Auth.get('signedIn')
      Ledger.Account.find(params.account_id)

  renderTemplate: ->
    @render 'accounts/show'

Ledger.AccountsNewRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
  model: ->
    null
  setupController: (controller, model) ->
    controller.set('content', model)
    controller.startEditing()

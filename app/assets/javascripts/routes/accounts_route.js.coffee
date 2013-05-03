Ledger.AccountsRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
  model: ->
    Ledger.Account.find()

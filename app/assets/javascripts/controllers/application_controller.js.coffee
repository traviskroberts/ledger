Ledger.ApplicationController = Ember.Controller.extend
  signOut: ->
    Ledger.Auth.signOut()

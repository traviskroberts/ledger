Ledger.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo 'accounts'

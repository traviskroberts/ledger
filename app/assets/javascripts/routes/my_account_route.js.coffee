Ledger.MyAccountRoute = Ember.Route.extend
  model: ->
    Ledger.Auth.get('user')
  setupController: (controller, model) ->
    controller.set('content', model)

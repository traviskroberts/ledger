Ledger.AccountsIndexRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
  model: ->
    @get('store').find('account')

Ledger.AccountRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
  model: (params) ->
    # if Ledger.Auth.get('signedIn')
    @get('store').find('account', params.url)

  renderTemplate: ->
    @render 'accounts/show'

# Ledger.AccountsNewRoute = Ember.Route.extend Ledger.Auth.AuthRedirectable,
#   model: ->
#     null
#   setupController: (controller, model) ->
#     controller.set('content', model)
#     controller.startEditing()

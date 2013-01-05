class Ledger.Routers.AppRouter extends Support.SwappingRouter
  initialize: (options) ->
    this.el = $('#backbone-container')
    this.accounts = options.accounts

  routes:
    'accounts'      : 'listAccounts'
    'accounts/:id'  : 'viewAccount'

  listAccounts: ->
    view = new Ledger.Views.AccountsIndex({collection: this.accounts})
    this.swap(view)

  viewAccount: (id) ->
    account = this.accounts.get(id)
    view = new Ledger.Views.AccountShow({model: account})
    this.swap(view)

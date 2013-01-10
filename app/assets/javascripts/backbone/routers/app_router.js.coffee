class Ledger.Routers.AppRouter extends Support.SwappingRouter
  initialize: (options) ->
    this.el = $('#backbone-container')
    this.accounts = options.accounts

  routes:
    'accounts'                              : 'listAccounts'
    'accounts/new'                          : 'newAccount'
    'accounts/:id'                          : 'viewAccount'
    'accounts/:id/edit'                     : 'editAccount'
    'accounts/:id/sharing'                  : 'listInvitations'
    'accounts/:id/recurring'                : 'listRecurring'
    'accounts/:id/recurring/new'            : 'newRecurring'
    'accounts/:acct_id/recurring/:id/edit'  : 'editRecurring'
    'users'                                 : 'listUsers'

  listAccounts: ->
    view = new Ledger.Views.AccountsIndex({collection: this.accounts})
    this.swap(view)

  newAccount: ->
    view = new Ledger.Views.AccountNew({collection: this.accounts})
    this.swap(view)

  viewAccount: (id) ->
    account = this.accounts.get(id)
    view = new Ledger.Views.AccountShow({model: account})
    this.swap(view)

  editAccount: (id) ->
    account = this.accounts.get(id)
    view = new Ledger.Views.AccountEdit({model: account})
    this.swap(view)

  listInvitations: (id) ->
    account = this.accounts.get(id)
    view = new Ledger.Views.InvitationsIndex({account: account})
    this.swap(view)

  listRecurring: (id) ->
    account = this.accounts.get(id)
    view = new Ledger.Views.RecurringTransactionsIndex({account: account})
    this.swap(view)

  newRecurring: (id) ->
    account = this.accounts.get(id)
    view = new Ledger.Views.RecurringTransactionNew({account: account})
    this.swap(view)

  editRecurring: (acct_id, id) ->
    account = this.accounts.get(acct_id)
    view = new Ledger.Views.RecurringTransactionEdit({account: account, id: id})
    this.swap(view)

  listUsers: ->
    view = new Ledger.Views.UsersIndex
    this.swap(view)

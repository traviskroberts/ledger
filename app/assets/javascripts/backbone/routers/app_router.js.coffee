class Ledger.Routers.AppRouter extends Support.SwappingRouter

  routes:
    ''                                      : 'landing'
    'login'                                 : 'login'
    'my-account'                            : 'myAccount'
    'accounts'                              : 'listAccounts'
    'accounts/new'                          : 'newAccount'
    'accounts/:id'                          : 'viewAccount'
    'accounts/:id/edit'                     : 'editAccount'
    'accounts/:id/sharing'                  : 'listInvitations'
    'accounts/:id/recurring'                : 'listRecurring'
    'accounts/:id/recurring/new'            : 'newRecurring'
    'accounts/:acct_id/recurring/:id/edit'  : 'editRecurring'
    'users'                                 : 'listUsers'

  initialize: (options) ->
    @el = $('#backbone-container')
    @user = new Ledger.Models.User()
    @accounts = new Ledger.Collections.Accounts()
    @renderNav()

  landing: ->
    if @authenticated()
      Backbone.history.navigate('accounts', true)

  login: ->
    view = new Ledger.Views.UserLogin({model: @user})
    @swap(view)

  myAccount: ->
    if @authenticated()
      view = new Ledger.Views.UserEdit({model: @user})
      @swap(view)

  listAccounts: ->
    if @authenticated()
      view = new Ledger.Views.AccountsIndex({collection: @accounts})
      @swap(view)

  newAccount: ->
    if @authenticated()
      view = new Ledger.Views.AccountNew({collection: @accounts})
      @swap(view)

  viewAccount: (id) ->
    if @authenticated()
      account = @accounts.get(id)
      view = new Ledger.Views.AccountShow({model: account})
      @swap(view)

  editAccount: (id) ->
    if @authenticated()
      account = @accounts.get(id)
      view = new Ledger.Views.AccountEdit({model: account})
      @swap(view)

  listInvitations: (id) ->
    if @authenticated()
      account = @accounts.get(id)
      view = new Ledger.Views.InvitationsIndex({account: account})
      @swap(view)

  listRecurring: (id) ->
    if @authenticated()
      account = @accounts.get(id)
      view = new Ledger.Views.RecurringTransactionsIndex({account: account})
      @swap(view)

  newRecurring: (id) ->
    if @authenticated()
      account = @accounts.get(id)
      view = new Ledger.Views.RecurringTransactionNew({account: account})
      @swap(view)

  editRecurring: (acct_id, id) ->
    if @authenticated()
      account = @accounts.get(acct_id)
      view = new Ledger.Views.RecurringTransactionEdit({account: account, id: id})
      @swap(view)

  listUsers: ->
    if @authenticated()
      view = new Ledger.Views.UsersIndex
      @swap(view)

  authenticated: ->
    if @user.get('id')?
      return true
    else
      Backbone.history.navigate('login', true)
      return false

  renderNav: ->
    if @authenticated()
      template = JST['backbone/templates/nav/authenticated']({user: @user.toJSON()})
    else
      template = JST['backbone/templates/nav/unauthenticated']

    $('#main-nav').html(template)

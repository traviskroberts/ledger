class Ledger.Routers.AppRouter extends Support.SwappingRouter

  routes:
    ''                                  : 'landing'
    'login'                             : 'login'
    'logout'                            : 'logout'
    'register'                          : 'register'
    'my-account'                        : 'myAccount'
    'accounts'                          : 'listAccounts'
    'accounts/new'                      : 'newAccount'
    'accounts/:url'                     : 'viewAccount'
    'accounts/:url/edit'                : 'editAccount'
    'accounts/:url/sharing'             : 'listInvitations'
    'accounts/:url/recurring'           : 'listRecurring'
    'accounts/:url/recurring/new'       : 'newRecurring'
    'accounts/:url/recurring/:id/edit'  : 'editRecurring'
    'users'                             : 'listUsers'

  initialize: ->
    @el = $('#backbone-container')

    # cache certain objects
    @user = new Ledger.Models.User()
    @accounts = new Ledger.Collections.Accounts()

    # see if the user is still authed
    if lscache.get('ledger_user')
      @user.set(lscache.get('ledger_user'))

    @accounts.fetch() if @authenticated()

    # show proper navigation
    @renderNav()

  landing: ->
    if @authenticated()
      Backbone.history.navigate('accounts', true)

  login: ->
    @cleanUp()
    view = new Ledger.Views.UserLogin({model: @user})
    @swap(view)

  logout: ->
    view = new Ledger.Views.UserLogout({model: @user, collection: @accounts})
    @swap(view)

  register: ->
    view = new Ledger.Views.UserNew({model: @user})
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

  viewAccount: (url) ->
    if @authenticated()
      account = @accounts.get(url)
      view = new Ledger.Views.AccountShow({model: account, url: url})
      @swap(view)

  editAccount: (url) ->
    if @authenticated()
      account = @accounts.get(url)
      view = new Ledger.Views.AccountEdit({model: account, url: url})
      @swap(view)

  listInvitations: (url) ->
    if @authenticated()
      account = @accounts.get(url)
      view = new Ledger.Views.InvitationsIndex({account: account, url: url})
      @swap(view)

  listRecurring: (url) ->
    if @authenticated()
      account = @accounts.get(url)
      view = new Ledger.Views.RecurringTransactionsIndex({account: account, url: url})
      @swap(view)

  newRecurring: (url) ->
    if @authenticated()
      account = @accounts.get(url)
      view = new Ledger.Views.RecurringTransactionNew({account: account, url: url})
      @swap(view)

  editRecurring: (url, id) ->
    if @authenticated()
      account = @accounts.get(url)
      view = new Ledger.Views.RecurringTransactionEdit({account: account, url: url, id: id})
      @swap(view)

  listUsers: ->
    if @authenticated()
      view = new Ledger.Views.UsersIndex
      @swap(view)

  authenticated: ->
    if @user.get('id')
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

  cleanUp: ->
    if @authenticated()
      lscache.remove('ledger_user')
      @user.clear()
      @accounts = new Ledger.Collections.Accounts() # reset() throws a validation error for some reason
      @renderNav()

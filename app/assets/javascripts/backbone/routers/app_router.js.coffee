class Ledger.Routers.AppRouter extends Backbone.Marionette.AppRouter
  routes:
    ""                                  : "landing"
    "login"                             : "login"
    "logout"                            : "logout"
    "register"                          : "register"
    "my-account"                        : "myAccount"
    "accounts"                          : "listAccounts"
    "accounts/new"                      : "newAccount"
    "accounts/:url"                     : "showAccount"
    "accounts/:url/edit"                : "editAccount"
    "accounts/:url/sharing"             : "listInvitations"
    "accounts/:url/recurring"           : "listRecurring"
    "accounts/:url/recurring/new"       : "newRecurring"
    "accounts/:url/recurring/:id/edit"  : "editRecurring"
    "users"                             : "listUsers"

  initialize: ->
    @bind "route", @_pageView

    @accountLoaded = false
    @entriesLoaded = false

    # cache certain objects
    @user = new Ledger.Models.User
    @accounts = new Ledger.Collections.Accounts

    # see if the user is still authed
    if user_data = lscache.get("ledger_user")
      @user.set(user_data)

    # show proper navigation
    @renderNav()

  landing: ->
    if @authenticated()
      Backbone.history.navigate("accounts", true)

  login: ->
    @cleanUp()

    view = new Ledger.Views.UserLogin({ model: @user })
    Ledger.main.show(view)

  logout: ->
    view = new Ledger.Views.UserLogout

  register: ->
    view = new Ledger.Views.UserNew({ model: @user })
    Ledger.main.show(view)

  myAccount: ->
    if @authenticated()
      view = new Ledger.Views.UserEdit({ model: @user })
      Ledger.main.show(view)

  listAccounts: ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        view = new Ledger.Views.AccountsIndex({ collection: @accounts })
        Ledger.main.show(view)

  newAccount: ->
    if @authenticated()
      account = new Ledger.Models.Account
      view = new Ledger.Views.AccountNew({ model: account, collection: @accounts })
      Ledger.main.show(view)

  showAccount: (url) ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        account = @accounts.findWhere({ url: url })
        entries = account.get("entries")
        entries.url = "/api/accounts/#{url}/entries"
        @_loadCollectionAndExecute entries, =>
          view = new Ledger.Views.AccountShow({ model: account, collection: entries })
          Ledger.main.show(view)

  editAccount: (url) ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        account = @accounts.get(url)
        view = new Ledger.Views.AccountEdit({ model: account, url: url })
        Ledger.main.show(view)

  listInvitations: (url) ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        account = @accounts.get(url)
        invitations = account.get("invitations")
        invitations.url = "/api/accounts/#{url}/invitations"
        @_loadCollectionAndExecute invitations, =>
          view = new Ledger.Views.InvitationsIndex({ account: account, collection: invitations })
          Ledger.main.show(view)

  listRecurring: (url) ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        account = @accounts.get(url)
        recurringTransactions = account.get("recurring_transactions")
        recurringTransactions.url = "/api/accounts/#{url}/recurring_transactions"
        @_loadCollectionAndExecute recurringTransactions, =>
          view = new Ledger.Views.RecurringTransactionsIndex({ account: account, collection: recurringTransactions })
          Ledger.main.show(view)

  newRecurring: (url) ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        account = @accounts.get(url)
        recurringTransactions = account.get("recurring_transactions")
        recurringTransactions.url = "/api/accounts/#{url}/recurring_transactions"
        @_loadCollectionAndExecute recurringTransactions, =>
          view = new Ledger.Views.RecurringTransactionNew({ account: account, collection: recurringTransactions })
          Ledger.main.show(view)

  editRecurring: (url, id) ->
    if @authenticated()
      @_loadAccountsAndExecute =>
        account = @accounts.get(url)
        recurringTransactions = account.get("recurring_transactions")
        recurringTransactions.url = "/api/accounts/#{url}/recurring_transactions"
        @_loadCollectionAndExecute recurringTransactions, =>
          recurringTransaction = recurringTransactions.get(id)
          recurringTransaction.url = "/api/accounts/#{url}/recurring_transactions/#{id}"
          view = new Ledger.Views.RecurringTransactionEdit({ model: recurringTransaction, account: account })
          Ledger.main.show(view)

  listUsers: ->
    if @authenticated()
      users = new Ledger.Collections.Users
      @_loadCollectionAndExecute users, =>
        debugger
        view = new Ledger.Views.UsersIndex({ collection: users })
        Ledger.main.show(view)

  authenticated: ->
    if @user.get("id")
      true
    else
      Backbone.history.navigate("login", true)
      false

  renderNav: ->
    if @authenticated()
      view = new Ledger.Views.AuthenticatedHeader({ model: @user })
    else
      view = new Ledger.Views.UnauthenticatedHeader

    Ledger.header.show(view)

  cleanUp: ->
    if @authenticated()
      @accountLoaded = false
      lscache.remove("ledger_user")
      @user.clear()
      # @accounts = new Ledger.Collections.Accounts # reset() throws a validation error for some reason
      @accounts.reset()
      @renderNav()

  _loadAccountsAndExecute: (callback) ->
    if @accountLoaded
      callback()
    else
      loadingView = new Ledger.Views.Loading
      Ledger.main.show(loadingView)
      @accounts.fetch
        success: =>
          @accountLoaded = true
          callback()

  _loadCollectionAndExecute: (collection, callback) ->
    if collection.length > 0
      callback()
    else
      collection.fetch
        success: =>
          callback()

  _pageView: ->
    url = Backbone.history.getFragment()
    ga("send", "pageview", { page: "/#{url}" })

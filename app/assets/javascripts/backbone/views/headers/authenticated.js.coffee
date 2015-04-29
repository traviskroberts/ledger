class Ledger.Views.AuthenticatedHeader extends Marionette.ItemView
  template: JST["backbone/templates/headers/authenticated"]
  className: "navbar-inner"

  ui:
    logoLink: ".js-home"
    accountsLink: ".js-accounts"
    myAccountLink: ".js-my-account"
    logoutLink: ".js-logout"

  events:
    "click @ui.logoLink": "navigateHomepage"
    "click @ui.accountsLink": "navigateAccounts"
    "click @ui.myAccountLink": "navigateMyAccount"
    "click @ui.logoutLink": "navigateLogout"

  navigateHomepage: (e) ->
    e.preventDefault()
    Backbone.history.navigate("", true)

  navigateAccounts: (e) ->
    e.preventDefault()
    Backbone.history.navigate("accounts", true)

  navigateMyAccount: (e) ->
    e.preventDefault()
    Backbone.history.navigate("my-account", true)

  navigateLogout: (e) ->
    e.preventDefault()
    Backbone.history.navigate("logout", true)

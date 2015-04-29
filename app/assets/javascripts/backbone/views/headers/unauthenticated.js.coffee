class Ledger.Views.UnauthenticatedHeader extends Marionette.ItemView
  template: JST["backbone/templates/headers/unauthenticated"]
  className: "navbar-inner"

  ui:
    logoLink: ".js-home"
    loginLink: ".js-login"
    registerLink: ".js-register"

  events:
    "click @ui.logoLink": "navigateHomepage"
    "click @ui.loginLink": "navigateLogin"
    "click @ui.registerLink": "navigateRegister"

  navigateHomepage: (e) ->
    e.preventDefault()
    Backbone.history.navigate("", true)

  navigateLogin: (e) ->
    e.preventDefault()
    Backbone.history.navigate("login", true)

  navigateRegister: (e) ->
    e.preventDefault()
    Backbone.history.navigate("register", true)

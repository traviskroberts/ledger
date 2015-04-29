class Ledger.Views.UserLogin extends Marionette.ItemView

  template: JST["backbone/templates/users/login"]

  ui:
    submitButton: ".btn-primary"
    registerButton: "#js-register"
    emailField: "#login_email"
    passwordField: "#login_password"
    rememberField: "#login_remember_me"

  events:
    "click @ui.registerButton": "navigateRegister"
    "submit form" : "authenticate"

  authenticate: (e) ->
    e.preventDefault()
    @$el.find(".alert").remove()
    @ui.submitButton.attr("disabled", "disabled")

    $.ajax
      url: "/api/user_session"
      type: "post"
      dataType: "json"
      data:
        user_session:
          email       : @ui.emailField.val()
          password    : @ui.passwordField.val()
          remember_me : @ui.rememberField.prop("checked")
      success: @onSuccess
      error: @onError

  onSuccess: (data) =>
    @model.set(data)
    lscache.set("ledger_user", @model.attributes, 43200) # save the user
    Ledger.router.renderNav()
    Backbone.history.navigate("accounts", true)

  onError: (xhr) =>
    @ui.submitButton.attr("disabled", false)
    data = JSON.parse(xhr.responseText)
    template = JST["backbone/templates/shared/validation_errors"]({ errors: data.errors })
    @$el.find("form").prepend(template)

  navigateRegister: (e) ->
    e.preventDefault()
    Backbone.history.navigate("register", true)

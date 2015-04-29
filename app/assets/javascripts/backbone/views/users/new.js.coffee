class Ledger.Views.UserNew extends Marionette.ItemView

  template: JST["backbone/templates/users/new"]

  ui:
    form: "form"
    submitButton: ".btn-primary"
    nameField: "#user_name"
    emailField: "#user_email"
    passwordField: "#user_password"
    passwordConfirmationField: "#user_password_confirmation"

  events:
    "submit @ui.form": "save"

  save: (e) ->
    e.preventDefault()
    @$el.find(".alert").remove()
    @ui.submitButton.attr("disabled", "disabled")

    $.ajax
      url: "/api/users"
      type: "post"
      dataType: "json"
      data:
        user:
          name                  : @ui.nameField.val()
          email                 : @ui.emailField.val()
          password              : @ui.passwordField.val()
          password_confirmation : @ui.passwordConfirmationField.val()
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
    @ui.form.prepend(template)

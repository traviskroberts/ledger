class Ledger.Views.UserEdit extends Marionette.ItemView
  template: JST["backbone/templates/users/edit"]

  ui:
    form: "form"
    name: "#user_name"
    email: "#user_email"
    password: "#user_password"
    passwordConfirmation: "#user_password_confirmation"
    submitButton: ".js-submit"
    cancelButton: ".js-cancel"

  events:
    "submit @ui.form": "save"
    "click @ui.cancelButton": "navigateAccounts"

  save: (e) ->
    e.preventDefault()
    @$el.find(".alert").remove()
    @ui.submitButton.attr("disabled", "disabled")

    params = {
      _method: "put"
      user: {
        name                  : @ui.name.val()
        email                 : @ui.email.val()
        password              : @ui.password.val()
        password_confirmation : @ui.passwordConfirmation.val()
      }
    }

    $.ajax
      url: "/api/user"
      type: "post"
      dataType: "json"
      data: params
      success: @onSuccess
      error: @onError

  onSuccess: (data) =>
    @model.set(data)
    lscache.set("ledger_user", @model.attributes, 43200)
    @ui.password.val("")
    @ui.passwordConfirmation.val("")
    @ui.submitButton.attr("disabled", false)
    template = JST["backbone/templates/shared/success_message"]({ msg: "Your information has been updated!" })
    @ui.form.prepend(template)

  onError: (xhr, status, errorText) =>
    @ui.submitButton.attr("disabled", false)
    data = JSON.parse(xhr.responseText)
    template = JST["backbone/templates/shared/validation_errors"]({ errors: data.errors })
    @ui.form.prepend(template)

  navigateAccounts: ->
    Backbone.history.navigate("accounts", true)

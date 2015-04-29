class Ledger.Views.AccountEdit extends Marionette.ItemView
  template: JST['backbone/templates/accounts/edit']

  ui:
    form: "form"
    backToAccounts: ".js-accounts"

  events:
    "submit @ui.form" : "save"
    "click @ui.backToAccounts": "navigateAccounts"

  save: (e) ->
    e.preventDefault()

    if @ui.form.valid()
      @model.save({ name: $("#account_name").val() }, success: @saved, error: @onError)

  saved: (model, resp, options) =>
    @model.set(resp)
    Backbone.history.navigate("accounts", true)

  onError: ->
    alert "There was an error updating that account."

  navigateAccounts: (e) ->
    e.preventDefault() if e
    Backbone.history.navigate("accounts", true)

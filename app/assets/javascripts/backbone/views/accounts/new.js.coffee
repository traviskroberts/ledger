class Ledger.Views.AccountNew extends Marionette.ItemView
  template: JST["backbone/templates/accounts/new"]

  ui:
    form: "form"
    nameField: "#account_name"
    balanceField: "#account_initial_balance"
    backButton: ".js-back-to-accounts"

  events:
    "submit @ui.form" : "save"
    "click @ui.backButton": "navigateAccounts"

  save: (e) ->
    e.preventDefault()
    if @ui.form.valid()
      @model.set
        name: @ui.nameField.val()
        initial_balance: @ui.balanceField.val()
      @model.save {},
        success: @saved,
        error: @onError

  saved: (model, resp, options) =>
    @model.set(resp)
    @collection.add(@model)
    @navigateAccounts()

  onError: ->
    alert "There was an error creating the account."

  navigateAccounts: (e) ->
    e.preventDefault() if e
    Backbone.history.navigate("accounts", true)

class Ledger.Views.RecurringTransactionNew extends Marionette.ItemView
  template: JST["backbone/templates/recurring_transactions/new"]

  ui:
    cancelBtn : ".js-cancel"
    form      : "form"

  events:
    "click @ui.cancelBtn" : "navigateAccount"
    "submit @ui.form"     : "save"

  initialize: (options) ->
    @account = options.account
    @account_url = @account.get("url")
    @model = new Ledger.Models.RecurringTransaction

  navigateAccount: ->
    Backbone.history.navigate("/accounts/#{@account_url}/recurring", true)

  save: (e) ->
    e.preventDefault()
    if @ui.form.valid()
      @model.url = "/api/accounts/#{@account_url}/recurring_transactions"
      @model.set
        float_amount: $("#float_amount").val()
        day: $("#day").val()
        description: $("#description").val()
      @model.save({}, success: @onSave, error: @onError)

  onSave: (model, resp, options) =>
    @model.set(resp)
    @collection.add(@model)
    Backbone.history.navigate("/accounts/#{@account_url}/recurring", true)

  onError: ->
    alert "There was an error creating the recurring transaction."

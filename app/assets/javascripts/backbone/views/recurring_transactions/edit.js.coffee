class Ledger.Views.RecurringTransactionEdit extends Marionette.ItemView
  template: JST["backbone/templates/recurring_transactions/edit"]

  ui:
    form: "form"
    cancelBtn: ".js-cancel"

  events:
    "click @ui.cancelBtn" : "navigateAccount"
    "submit @ui.form"     : "save"

  initialize: (opts) ->
    @account = opts.account
    @account_url = @account.get("url")

  serializeData: ->
    data = Marionette.ItemView.prototype.serializeData.apply(@)
    data.account = @account.toJSON()

    data

  navigateAccount: ->
    Backbone.history.navigate("accounts/#{@account_url}/recurring", true)

  save: (e) ->
    e.preventDefault()
    if @ui.form.valid()
      @model.set
        float_amount: $('#float_amount').val()
        day: $('#day').val()
        description: $('#description').val()
      @model.save({}, success: @onSave, error: @onError)

  onSave: =>
    Backbone.history.navigate("/accounts/#{@account_url}/recurring", true)

  onError: ->
    alert "There was an error updating the recurring transaction."

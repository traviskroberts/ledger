class Ledger.Views.RecurringTransactionItem extends Marionette.ItemView
  tagName: "tr"
  template: JST["backbone/templates/recurring_transactions/item"]

  ui:
    editBtn: ".js-edit"
    deleteBtn: ".js-delete"

  events:
    "click @ui.editBtn" : "editItem"
    "click @ui.deleteBtn" : "deleteItem"

  editItem: ->
    url = "accounts/#{@options.accountUrl}/recurring/#{@model.id}/edit"
    Backbone.history.navigate(url, true)

  deleteItem: ->
    @model.url = "/api/accounts/#{@options.accountUrl}/recurring_transactions/#{@model.id}"
    @model.destroy
      error: ->
        alert "That recurring transaction could not be removed."

# ==============================================================================

class Ledger.Views.RecurringTransactionsIndex extends Marionette.CompositeView
  tagName: "span"
  template: JST["backbone/templates/recurring_transactions/index"]

  childView: Ledger.Views.RecurringTransactionItem
  childViewContainer: "#recurring-transactions-list"
  childViewOptions: ->
    accountUrl: @account_url

  ui:
    accountLink: ".js-account"
    newBtn: ".js-new-recurring-transaction"

  events:
    "click @ui.accountLink": "navigateAccount"
    "click @ui.newBtn": "newRecurringTransaction"

  initialize: (opts) ->
    @account = opts.account
    @account_url = @account.get("url")

  serializeData: ->
    data = Marionette.CompositeView.prototype.serializeData.apply(@)
    data.account = @account.toJSON()
    data.recurring_transactions = @collection.length

    data

  navigateAccount: (e) ->
    e.preventDefault()
    Backbone.history.navigate("accounts/#{@account_url}", true)

  newRecurringTransaction: (e) ->
    e.preventDefault()
    Backbone.history.navigate("accounts/#{@account_url}/recurring/new", true)

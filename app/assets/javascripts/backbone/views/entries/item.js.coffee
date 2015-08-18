class Ledger.Views.EntryItem extends Marionette.ItemView
  tagName: "tr"
  template: JST["backbone/templates/entries/item"]

  ui:
    editButton: ".edit-entry"
    cancelButton: ".cancel-edit"
    deleteButton: ".delete-entry"
    entryForm: ".entry-edit-form"

  events:
    "click @ui.editButton"    : "editEntry"
    "click @ui.cancelButton"  : "cancelEdit"
    "click @ui.deleteButton"  : "deleteEntry"
    "submit @ui.entryForm"    : "updateEntry"

  initialize: ->
    @account = @model.get("account")

  editEntry: (e) ->
    @$el.html(JST["backbone/templates/entries/edit"](@model.attributes))
    if $(e.currentTarget).attr("data-field") == "description"
      @$el.find(".entry-description-field").focus()
    else if $(e.currentTarget).attr("data-field") == "date"
      @$el.find(".entry-date-field").focus()
    else
      @$el.find(".entry-amount-field").focus()

  cancelEdit: (e) ->
    e.preventDefault()

    @$el.html @template(@model.toJSON())

  updateEntry: (e) ->
    e.preventDefault()

    form_date = @$el.find(".entry-date-field").val()
    @model.url = "/api/accounts/#{@account.get("url")}/entries/#{@model.id}"
    @model.set
      description: @$el.find(".entry-description-field").val()
      date: moment(form_date).format("YYYY-MM-DD")
      float_amount: @$el.find(".entry-amount-field").val()

    @model.save {},
      success: @updated
      error: @onError

  updated: (model, resp, options) =>
    @model.set
      id: resp.entry.id
      classification: resp.entry.classification
      description: resp.entry.description
      formatted_date: resp.entry.formatted_date
      timestamp: resp.entry.timestamp
      formatted_amount: resp.entry.formatted_amount
      form_amount_value: resp.entry.form_amount_value
    @account.set(dollar_balance: resp.account_balance)
    @$el.html @template(@model.toJSON())

  onError: =>
    alert "There was an error updating the entry."

  deleteEntry: (e) ->
    e.preventDefault()
    @model.url = "/api/accounts/#{@account.get("url")}/entries/#{@model.id}"
    @model.destroy(success: @onDelete)

  onDelete: (model, resp, options) =>
    @account.set(dollar_balance: resp.balance)

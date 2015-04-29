class Ledger.Views.AccountShow extends Marionette.CompositeView
  template: JST["backbone/templates/accounts/show"]

  ui:
    accountsLink: ".js-accounts"
    recurringTransactionsLink: ".js-recurring-transactions"
    newEntryForm: ".new-entry"
    entryAmountField: "#entry_float_amount"
    entryDescriptionField: "#entry_description"
    newEntryButton: ".js-new-entry"
    searchField: "#search"
    clearButton: ".btn-clear"
    paginationLink: ".js-pagination"

  events:
    "click @ui.accountsLink": "navigateAccounts"
    "click @ui.recurringTransactionsLink": "navigateRecurringTransactions"
    "submit @ui.newEntryForm": "addEntry"
    "keyup @ui.searchField": "liveSearch"
    "click @ui.clearButton": "resetSearch"
    "click @ui.paginationLink": "goToPage"

  initialize: (options) ->
    @modelBinder = new Backbone.ModelBinder
    @childView = Ledger.Views.EntryItem
    @childViewContainer = "#entries-list"
    @autocompleteStarted = false

  serializeData: ->
    data = @model.attributes
    data.currentPage = @collection.state.currentPage
    data.pageSize = @collection.state.pageSize
    data.totalRecords = @collection.state.totalRecords

    if @collection.state.currentPage < @collection.state.totalPages
      data.nextPage = @collection.state.currentPage + 1
    else
      data.nextPage = null

    if @collection.state.currentPage > 1
      data.previousPage = @collection.state.currentPage - 1
    else
      data.previousPage = null

    data

  onRender: ->
    @modelBinder.bind(@model, @el)

  onShow: ->
    @setupAutocomplete()

  onClose: ->
    @modelBinder.unbind()

  setupAutocomplete: ->
    if @ui.entryDescriptionField.length
      request_url = @collection.url + "/values"
      @ui.entryDescriptionField.autocomplete
        minLength: 2
        source: (req, resp) ->
          $.ajax
            url: request_url
            dataType: "json"
            data:
              term: req.term
            success: (data) ->
              resp(data.values)

  navigateAccounts: (e) ->
    e.preventDefault()
    Backbone.history.navigate("accounts", true)

  navigateRecurringTransactions: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).attr("href")
    Backbone.history.navigate(url, true)

  validateEntryForm: ->
    @ui.newEntryForm.validate
      onfocusout: false
      onkeyup: false
      onclick: false
      groups:
        entry_fields: "entry_float_amount entry_description"

  addEntry: ->
    if @ui.newEntryForm.valid()
      @ui.newEntryButton.button("loading")
      @entry = new Ledger.Models.Entry
        float_amount: @ui.entryAmountField.val()
        description: @ui.entryDescriptionField.val()
        account_id: @model.get("id")
      @entry.url = "/api/accounts/" + @model.get("url") + "/entries"
      @entry.save({}, { success: @entryAdded, error: @onError })
    false

  entryAdded: (model, resp, options) =>
    @ui.entryAmountField.val("")
    @ui.entryDescriptionField.val("")
    @ui.newEntryButton.button("reset")
    @model.set
      dollar_balance: resp.account_balance
    @entry.set(resp.entry)
    @entry.set
      account: @model

  onError: =>
    alert "There was an error adding the entry."

  liveSearch: (e) ->
    clearTimeout(@timeout)
    queryString = $(e.currentTarget).val()
    return if queryString.length < 3

    @ui.clearButton.show()
    @timeout = setTimeout =>
      @searchEntries(queryString)
    , 150

  searchEntries: (queryString) ->
    $.ajax
      url: @collection.url + "/search"
      type: "post"
      dataType: "json"
      data:
        query: queryString
      success: (data) =>
        @collection.reset(data)
        @$(".pagination, .pagination-info").hide()

  resetSearch: ->
    @ui.searchField.val("")
    @ui.clearButton.hide()
    @collection.fetch()

  goToPage: (e) ->
    e.preventDefault()
    page = $(e.currentTarget).data("page")
    if page
      @collection.getPage(page)

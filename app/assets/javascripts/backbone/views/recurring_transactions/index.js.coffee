class Ledger.Views.RecurringTransactionsIndex extends Support.CompositeView
  tagName: 'span'

  initialize: (options) ->
    _.bindAll @, 'render', 'renderItems'

    @account = options.account
    unless @account?
      @account = new Ledger.Models.Account({url: options.url})
      @bindTo @account, 'sync', @render
      @account.fetch()

    if @account.get('recurring_transactions').length == 0
      @collection = new Ledger.Collections.RecurringTransactions
    else
      @collection = @account.get('recurring_transactions')

    @collection.url = '/api/accounts/' + @account.get('url') + '/recurring_transactions'
    @bindTo @collection, 'sync', @render
    @bindTo @collection, 'change', @render
    @bindTo @collection, 'remove', @render

    if @collection.length == 0
      @account.set('recurring_transactions': @collection)
      @collection.fetch()

  render: ->
    template = JST['backbone/templates/recurring_transactions/index']({account: @account.toJSON(), recurring_transactions: @collection.toJSON()})
    @$el.html(template)
    if @collection.length > 0
      @renderItems()
    @

  renderItems: ->
    @collection.each (recurring_transaction) =>
      row = new Ledger.Views.RecurringTransactionItem({model: recurring_transaction, account: @account})
      @renderChild(row)
      @$('#recurring-transactions-list').append(row.el)

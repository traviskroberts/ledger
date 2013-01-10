class Ledger.Views.RecurringTransactionsIndex extends Support.CompositeView
  tagName: 'span'

  initialize: (options) ->
    _.bindAll this, 'render', 'renderItems'

    this.account = options.account
    if this.account.get('recurring_transactions').length == 0
      this.collection = new Ledger.Collections.RecurringTransactions
    else
      this.collection = this.account.get('recurring_transactions')

    this.collection.url = '/api/accounts/' + this.account.get('url') + '/recurring_transactions'
    this.collection.bind 'sync', this.render
    this.collection.bind 'change', this.render
    this.collection.bind 'remove', this.render

    if this.collection.length == 0
      this.account.set('recurring_transactions': this.collection)
      this.collection.fetch()

  render: ->
    template = JST['backbone/templates/recurring_transactions/index']({account: this.account.toJSON(), recurring_transactions: this.collection.toJSON()})
    this.$el.html(template)
    if this.collection.length > 0
      this.renderItems()
    this

  renderItems: ->
    this.collection.each (recurring_transaction) =>
      row = new Ledger.Views.RecurringTransactionItem({model: recurring_transaction})
      this.renderChild(row)
      this.$('#recurring-transactions-list').append(row.el)

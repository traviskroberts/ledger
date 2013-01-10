class Ledger.Views.RecurringTransactionItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .delete' : 'deleteIten'

  initialize: ->
    _.bindAll this, 'render'
    this.account = this.model.get('account')
    this.model.url = '/api/accounts/' + this.account.get('url') + '/recurring_transactions/' + this.model.get('id')

  render: ->
    template = JST['backbone/templates/recurring_transactions/item']
      account: this.account.toJSON()
      recurring_transaction: this.model.toJSON()
    this.$el.html(template)
    this

  deleteIten: (e) ->
    e.preventDefault()
    this.model.destroy
      error: ->
        alert 'That recurring transaction could not be removed.'

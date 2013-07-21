class Ledger.Views.RecurringTransactionItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .delete' : 'deleteItem'

  initialize: (options) ->
    _.bindAll @, 'render', 'deleteItem'
    @account = options.account
    @model.url = '/api/accounts/' + @account.get('url') + '/recurring_transactions/' + @model.get('id')

  render: ->
    template = JST['backbone/templates/recurring_transactions/item']
      account: @account.toJSON()
      recurring_transaction: @model.toJSON()
    @$el.html(template)
    @

  deleteItem: (e) ->
    e.preventDefault()
    @model.destroy
      error: ->
        alert 'That recurring transaction could not be removed.'

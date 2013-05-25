class Ledger.Views.RecurringTransactionItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .delete' : 'deleteItem'

  initialize: ->
    _.bindAll @, 'render', 'deleteItem'
    @account = @model.get('account')
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

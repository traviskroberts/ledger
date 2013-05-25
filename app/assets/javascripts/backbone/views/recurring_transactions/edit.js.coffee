class Ledger.Views.RecurringTransactionEdit extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'save', 'saved'
    @account = options.account
    @id = options.id
    if @account.get('recurring_transactions').length == 0
      @collection = new Ledger.Collections.RecurringTransactions
    else
      @collection = @account.get('recurring_transactions')

    @collection.url = '/api/accounts/' + @account.get('url') + '/recurring_transactions'
    @collection.bind 'sync', @render

    if @collection.length == 0
      @account.set('recurring_transactions': @collection)
      @collection.fetch()

  events:
    'submit form' : 'save'

  render: ->
    @model = @collection.get(@id)

    if @model
      @model.url = '/api/accounts/' + @account.get('url') + '/recurring_transactions/' + @id
      template = JST['backbone/templates/recurring_transactions/edit']
        account: @account.toJSON(),
        recurring_transaction: @model.toJSON()
      @$el.html(template)

    @

  save: (e) ->
    e.preventDefault()
    if @$('form').valid()
      @model.set
        float_amount: $('#float_amount').val()
        day: $('#day').val()
        description: $('#description').val()
      @model.save({}, success: @saved, error: @onError)

  saved: (model, resp, options) ->
    @model.set(resp)
    Backbone.history.navigate('/accounts/' + @account.get('url') + '/recurring', true)

  onError: ->
    alert 'There was an error updating the recurring transaction.'

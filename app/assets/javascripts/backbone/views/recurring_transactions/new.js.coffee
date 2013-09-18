class Ledger.Views.RecurringTransactionNew extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'save', 'saved'

    @account = options.account
    unless @account?
      @account = new Ledger.Models.Account({url: options.url})
      @bindTo @account, 'sync', @render
      @account.fetch()

    @collection = @account.get('recurring_transactions')
    @model = new Ledger.Models.RecurringTransaction

  events:
    'submit form' : 'save'

  render: ->
    template = JST['backbone/templates/recurring_transactions/new']({account: @account.toJSON()})
    @$el.html(template)
    @

  save: (e) ->
    e.preventDefault()
    if @$('form').valid()
      @model.url = '/api/accounts/' + @account.get('url') + '/recurring_transactions'
      @model.set
        float_amount: $('#float_amount').val()
        day: $('#day').val()
        description: $('#description').val()
      @model.save({}, success: @saved, error: @onError)

  saved: (model, resp, options) ->
    @model.set(resp)
    @collection.add(@model)
    Backbone.history.navigate('/accounts/' + @account.get('url') + '/recurring', true)

  onError: ->
    alert 'There was an error creating the recurring transaction.'

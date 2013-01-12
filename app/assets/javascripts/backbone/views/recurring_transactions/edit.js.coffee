class Ledger.Views.RecurringTransactionEdit extends Support.CompositeView

  initialize: (options) ->
    _.bindAll this, 'render', 'save', 'saved'
    this.account = options.account
    this.id = options.id
    if this.account.get('recurring_transactions').length == 0
      this.collection = new Ledger.Collections.RecurringTransactions
    else
      this.collection = this.account.get('recurring_transactions')

    this.collection.url = '/api/accounts/' + this.account.get('url') + '/recurring_transactions'
    this.collection.bind 'sync', this.render

    if this.collection.length == 0
      this.account.set('recurring_transactions': this.collection)
      this.collection.fetch()

  events:
    'submit form' : 'save'

  render: ->
    this.model = this.collection.get(this.id)

    if this.model
      this.model.url = '/api/accounts/' + this.account.get('url') + '/recurring_transactions/' + this.id
      template = JST['backbone/templates/recurring_transactions/edit']
        account: this.account.toJSON(),
        recurring_transaction: this.model.toJSON()
      this.$el.html(template)

    this

  save: (e) ->
    e.preventDefault()
    if this.$('form').valid()
      this.model.set
        float_amount: $('#float_amount').val()
        day: $('#day').val()
        description: $('#description').val()
      this.model.save({}, success: this.saved, error: this.onError)

  saved: (model, resp, options) ->
    this.model.set(resp)
    Backbone.history.navigate('/accounts/' + this.account.get('url') + '/recurring', true)

  onError: ->
    alert 'There was an error updating the recurring transaction.'

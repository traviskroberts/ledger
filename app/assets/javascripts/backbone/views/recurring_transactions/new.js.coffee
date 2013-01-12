class Ledger.Views.RecurringTransactionNew extends Support.CompositeView

  initialize: (options) ->
    _.bindAll this, 'render', 'save', 'saved'
    this.account = options.account
    this.collection = this.account.get('recurring_transactions')
    this.model = new Ledger.Models.RecurringTransaction

  events:
    'submit form' : 'save'

  render: ->
    template = JST['backbone/templates/recurring_transactions/new']({account: this.account.toJSON()})
    this.$el.html(template)
    this

  save: (e) ->
    e.preventDefault()
    if this.$('form').valid()
      this.model.url = '/api/accounts/' + this.account.get('url') + '/recurring_transactions'
      this.model.set
        float_amount: $('#float_amount').val()
        day: $('#day').val()
        description: $('#description').val()
      this.model.save({}, success: this.saved, error: this.onError)

  saved: (model, resp, options) ->
    this.model.set(resp)
    this.collection.add(this.model)
    Backbone.history.navigate('/accounts/' + this.account.get('url') + '/recurring', true)

  onError: ->
    alert 'There was an error creating the recurring transaction.'

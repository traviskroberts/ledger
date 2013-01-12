class Ledger.Views.AccountNew extends Support.CompositeView

  initialize: ->
    _.bindAll this, 'render', 'save', 'saved'
    this.model = new Ledger.Models.Account

  events:
    'submit form' : 'save'

  render: ->
    template = JST['backbone/templates/accounts/new']
    this.$el.html(template)
    this

  save: (e) ->
    e.preventDefault()
    if this.$('form').valid()
      this.model.set
        name: $('#account_name').val()
        initial_balance: $('#account_initial_balance').val()
      this.model.save({}, success: this.saved, error: this.onError)

  saved: (model, resp, options) ->
    this.model.set(resp)
    this.collection.add(this.model)
    Backbone.history.navigate('/accounts', true)

  onError: ->
    alert 'There was an error creating the account.'

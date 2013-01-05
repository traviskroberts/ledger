class Ledger.Views.AccountEdit extends Support.CompositeView

  initialize: ->
    _.bindAll this, 'render', 'save', 'saved'

  events:
    'submit form' : 'save'

  render: ->
    template = JST['backbone/templates/accounts/edit']({account: this.model.toJSON()})
    this.$el.html(template)
    this

  save: (e) ->
    e.preventDefault()
    this.model.save({name: $('#account_name').val()}, success: this.saved, error: this.onError)

  saved: (model, resp, options) ->
    this.model.set(resp)
    Backbone.history.navigate('/accounts', true)

  onError: ->
    alert 'There was an error updating the account.'

class Ledger.Views.AccountNew extends Support.CompositeView

  initialize: ->
    _.bindAll @, 'render', 'save', 'saved'
    @model = new Ledger.Models.Account

  events:
    'submit form' : 'save'

  render: ->
    template = JST['backbone/templates/accounts/new']
    @$el.html(template)
    @

  save: (e) ->
    e.preventDefault()
    if @$('form').valid()
      @model.set
        name: $('#account_name').val()
        initial_balance: $('#account_initial_balance').val()
      @model.save({}, success: @saved, error: @onError)

  saved: (model, resp, options) ->
    @model.set(resp)
    @collection.add(@model)
    Backbone.history.navigate('/accounts', true)

  onError: ->
    alert 'There was an error creating the account.'

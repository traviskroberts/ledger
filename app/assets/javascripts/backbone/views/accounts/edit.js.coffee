class Ledger.Views.AccountEdit extends Support.CompositeView

  initialize: ->
    _.bindAll @, 'render', 'save', 'saved'

  events:
    'submit form' : 'save'

  render: ->
    template = JST['backbone/templates/accounts/edit']({account: @model.toJSON()})
    @$el.html(template)
    @

  save: (e) ->
    e.preventDefault()
    if @$('form').valid()
      @model.save({name: $('#account_name').val()}, success: @saved, error: @onError)

  saved: (model, resp, options) ->
    @model.set(resp)
    Backbone.history.navigate('/accounts', true)

  onError: ->
    alert 'There was an error updating the account.'

class Ledger.Views.AccountItem extends Support.CompositeView
  className: 'span12'

  events:
    'click .delete' : 'deleteAccount'

  initialize: ->
    _.bindAll @, 'render', 'deleteAccount'

  render: ->
    @$el.html(JST['backbone/templates/accounts/item'](account: @model.toJSON()))
    @

  deleteAccount: (e) ->
    e.preventDefault()
    if confirm('Are you sure you want to delete this account?')
      @model.destroy
        error: ->
          alert 'That account could not be removed.'

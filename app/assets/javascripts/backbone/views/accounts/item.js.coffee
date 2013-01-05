class Ledger.Views.AccountItem extends Support.CompositeView
  className: 'span4'

  events:
    'click .delete' : 'deleteAccount'

  initialize: ->
    _.bindAll this, 'render'

  render: ->
    this.$el.html(JST['backbone/templates/accounts/item'](account: this.model.toJSON()))
    this

  deleteAccount: (e) ->
    e.preventDefault()
    this.model.destroy
      error: ->
        alert 'That account could not be removed.'

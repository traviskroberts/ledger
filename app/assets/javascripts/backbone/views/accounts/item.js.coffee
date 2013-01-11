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
    if confirm('Are you sure you want to delete this account?')
      this.model.destroy
        error: ->
          alert 'That account could not be removed.'

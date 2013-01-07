class Ledger.Views.UserItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .delete' : 'deleteUser'

  initialize: ->
    _.bindAll this, 'render'

  render: ->
    this.$el.html(JST['backbone/templates/users/item'](user: this.model.toJSON()))
    this

  deleteUser: (e) ->
    e.preventDefault()
    this.model.destroy
      error: ->
        alert 'That user could not be deleted.'

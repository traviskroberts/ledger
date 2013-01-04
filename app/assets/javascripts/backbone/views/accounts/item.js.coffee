class Ledger.Views.AccountItem extends Support.CompositeView
  className: "span4"

  # events:
  #   'click .close': 'delete_account'

  initialize: ->
    _.bindAll this, 'render'

  render: ->
    this.$el.html(JST['backbone/templates/accounts/item'](account: this.model.toJSON()))
    this

  # delete_account: (event) ->
  #   this.model.destroy()
  #   event.preventDefault()

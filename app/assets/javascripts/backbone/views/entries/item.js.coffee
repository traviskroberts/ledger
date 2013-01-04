class Ledger.Views.EntryItem extends Support.CompositeView
  tagName: "li"

  # events:
  #   'click .delete-entry': 'delete_entry'

  initialize: (options) ->
    _.bindAll this, 'render'

  render: ->
    account = this.model.get('account')
    this.$el.html(JST['backbone/templates/entries/item']({entry: this.model.toJSON(), account: account.toJSON()}))
    this

  # delete_entry: (event) ->
  #   this.model.destroy()
  #   event.preventDefault()

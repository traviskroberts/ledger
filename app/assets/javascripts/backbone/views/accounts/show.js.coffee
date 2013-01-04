class Ledger.Views.AccountShow extends Support.CompositeView
  initialize: ->
    _.bindAll this, 'render'

  render: ->
    this.$el.html(JST['backbone/templates/accounts/show']({account: this.model.toJSON()}))
    this.renderEntries()
    this

  renderEntries: ->
    this.model.get('entries').each (entry) =>
      row = new Ledger.Views.EntryItem({model: entry})
      this.renderChild(row)
      this.$('#entries').append(row.el)

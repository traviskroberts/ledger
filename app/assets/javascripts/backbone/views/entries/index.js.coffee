class Ledger.Views.EntryIndex extends Support.CompositeView

  initialize: (options) ->
    _.bindAll this, 'render', 'renderEntries', 'goToPage'
    this.account = options.account

  events:
    'click .pagination a': 'goToPage'

  render: ->
    this.$el.html(JST['backbone/templates/entries/index']({entries: this.collection.toJSON(), account: this.account.toJSON(), pagination: this.collection.info()}))
    if this.collection.length > 0
      this.renderEntries()
    this

  renderEntries: ->
    this.collection.each (entry) =>
      row = new Ledger.Views.EntryItem({model: entry, account: this.account})
      this.renderChild(row)
      this.$('#entries-list').append(row.el)

  goToPage: (e) ->
    e.preventDefault()
    page = parseInt($(e.target).attr('data-page'), 10)
    if page
      this.collection.goTo(page)

class Ledger.Views.EntryIndex extends Marionette.ItemView

  initialize: (options) ->
    _.bindAll @, 'render', 'renderEntries', 'goToPage'
    @account = options.account

  events:
    'click .pagination a': 'goToPage'

  render: ->
    @$el.html(JST['backbone/templates/entries/index']({entries: @collection.toJSON(), account: @account.toJSON(), pagination: @collection.info()}))
    if @collection.length > 0
      @renderEntries()
    @

  renderEntries: ->
    @collection.each (entry) =>
      row = new Ledger.Views.EntryItem({model: entry, account: @account})
      @renderChild(row)
      @$('#entries-list').append(row.el)

  goToPage: (e) ->
    e.preventDefault()
    page = parseInt($(e.target).attr('data-page'), 10)
    if page
      @collection.goTo(page)

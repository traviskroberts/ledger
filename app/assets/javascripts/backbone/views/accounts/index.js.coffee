class Ledger.Views.AccountsIndex extends Support.CompositeView
  tagName: 'span'

  initialize: ->
    _.bindAll @, 'render', 'renderAccounts'
    @collection.bind 'change', @render
    @collection.bind 'remove', @render
    @collection.bind 'sync', @render

    if @collection.length == 0
      @collection.fetch()

  render: ->
    @$el.html(JST['backbone/templates/accounts/index'])
    @renderAccounts()
    @

  renderAccounts: ->
    @collection.each (account) =>
      row = new Ledger.Views.AccountItem({ model: account })
      @renderChild(row)
      @$('#accounts-list').append(row.el)

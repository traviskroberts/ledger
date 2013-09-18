class Ledger.Views.AccountsIndex extends Support.CompositeView
  tagName: 'span'

  initialize: ->
    _.bindAll @, 'render', 'renderAccounts'

    @bindTo @collection, 'change', @renderAccounts
    @bindTo @collection, 'remove', @renderAccounts
    @bindTo @collection, 'sync', @renderAccounts

    if @collection.length == 0
      @collection.fetch()

  render: ->
    @$el.html(JST['backbone/templates/accounts/index'])
    @renderAccounts() unless @collection.length == 0
    @

  renderAccounts: ->
    if @collection.length == 0
      @$('#accounts-list').html("<p>You don't have any accounts yet.</p>")
    else
      @$('#accounts-list').html('')
      @collection.each (account) =>
        row = new Ledger.Views.AccountItem({ model: account })
        @renderChild(row)
        @$('#accounts-list').append(row.el)

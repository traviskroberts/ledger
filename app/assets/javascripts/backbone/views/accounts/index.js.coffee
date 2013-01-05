class Ledger.Views.AccountsIndex extends Support.CompositeView
  tagName: 'span'

  initialize: ->
    _.bindAll this, 'render', 'renderTemplate', 'renderAccounts'
    this.collection.bind 'all', (event) ->
      console.log 'Event fired for collection', event
    this.collection.bind 'remove', this.render

  render: ->
    this.renderTemplate()
    this.renderAccounts()
    this

  renderTemplate: ->
    this.$el.html(JST['backbone/templates/accounts/index'])

  renderAccounts: ->
    this.collection.each (account) =>
      row = new Ledger.Views.AccountItem({ model: account })
      this.renderChild(row)
      this.$('#accounts-list').append(row.el)

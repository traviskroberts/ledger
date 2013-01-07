class Ledger.Views.AccountsIndex extends Support.CompositeView
  tagName: 'span'

  initialize: ->
    _.bindAll this, 'render', 'renderAccounts'
    this.collection.bind 'change', this.render
    this.collection.bind 'remove', this.render

  render: ->
    this.$el.html(JST['backbone/templates/accounts/index'])
    this.renderAccounts()
    this

  renderAccounts: ->
    this.collection.each (account) =>
      row = new Ledger.Views.AccountItem({ model: account })
      this.renderChild(row)
      this.$('#accounts-list').append(row.el)

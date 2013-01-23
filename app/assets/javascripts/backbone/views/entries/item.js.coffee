class Ledger.Views.EntryItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .delete-entry': 'deleteEntry'

  initialize: (options) ->
    _.bindAll this, 'render', 'deleteEntry', 'onDelete'
    this.account = options.account

  render: ->
    account = this.model.get('account')
    this.$el.html(JST['backbone/templates/entries/item']({entry: this.model.toJSON(), account: account.toJSON()}))
    this

  deleteEntry: (event) ->
    event.preventDefault()
    this.model.urlRoot = '/api/accounts/' + this.account.get('url') + '/entries'
    this.model.destroy(success: this.onDelete)

  onDelete: (model, resp, options) ->
    this.account.set(dollar_balance: resp.balance)

class Ledger.Views.AccountShow extends Support.CompositeView

  initialize: ->
    _.bindAll this, 'render', 'renderEntries', 'entryAdded'

    this.model.bind 'add:entries', this.render
    if this.model.get('entries').length == 0
      this.entries = new Ledger.Collections.Entries
    else
      this.entries = this.model.get('entries')

    this.entries.url = '/api/accounts/' + this.model.get('url') + '/entries'
    this.entries.bind 'sync', this.renderEntries

    if this.entries.length == 0
      this.model.set('entries': this.entries)
      this.entries.fetch()

  events:
    'submit form' : 'addEntry'

  render: ->
    template = JST['backbone/templates/accounts/show']({account: this.model.toJSON()})
    this.$el.html(template)
    if this.entries.length > 0
      this.renderEntries()
    this

  renderEntries: ->
    this.$('#entries').html('')
    this.entries.each (entry) =>
      row = new Ledger.Views.EntryItem({model: entry})
      this.renderChild(row)
      this.$('#entries').append(row.el)

  addEntry: ->
    this.entry = new Ledger.Models.Entry
      float_amount: $('#entry_float_amount').val()
      description: $('#entry_description').val()
      account_id: this.model.get('id')
    this.entry.url = '/api/accounts/' + this.model.get('url') + '/entries'
    this.entry.save({}, {success: this.entryAdded, error: this.onError})
    false

  entryAdded: (model, resp, options) ->
    $('#entry_float_amount').val('')
    $('#entry_description').val('')
    this.model.set
      dollar_balance: resp.account_balance
    this.entry.set(resp.entry)
    this.entry.set
      account: this.model

  onError: ->
    alert 'There was an error adding the entry.'

class Ledger.Views.AccountShow extends Support.CompositeView

  initialize: ->
    _.bindAll this, 'render', 'validateEntryForm', 'renderEntries', 'entryAdded'

    this.model.bind 'add:entries', this.render
    this.model.bind 'remove:entries', this.render
    this.model.bind 'change', this.render
    if this.model.get('entries').length == 0
      this.entries = new Ledger.Collections.Entries
      # this.entries.setSort('id', 'desc')
    else
      this.entries = this.model.get('entries')

    this.entries.paginator_core.url = '/api/accounts/' + this.model.get('url') + '/entries'
    this.entries.bind 'sync', this.renderEntries

    if this.entries.length == 0
      this.model.set('entries': this.entries)
      this.entries.fetch()

  events:
    'submit form' : 'addEntry'

  render: ->
    template = JST['backbone/templates/accounts/show']({account: this.model.toJSON()})
    this.$el.html(template)
    this.validateEntryForm()
    if this.entries.length > 0
      this.renderEntries()
    this

  renderEntries: ->
    this.$('#entries').html('')
    row = new Ledger.Views.EntryIndex({collection: this.entries, account: this.model})
    this.renderChild(row)
    this.$('#entries').append(row.el)

  validateEntryForm: ->
    this.$('form').validate
      groups:
        entry_fields: "entry_float_amount entry_description"

  addEntry: ->
    if this.$('form').valid()
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

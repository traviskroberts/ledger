class Ledger.Views.AccountShow extends Support.CompositeView
  events:
    'click #add-entry' : 'addEntry'

  initialize: ->
    _.bindAll this, 'render', 'renderNewEntry', 'entryAdded'
    this.model.bind('add:entries', this.renderNewEntry);

  render: ->
    this.$el.html(JST['backbone/templates/accounts/show']({account: this.model.toJSON()}))
    this.renderEntries()
    this

  renderEntries: ->
    this.model.get('entries').each (entry) =>
      row = new Ledger.Views.EntryItem({model: entry})
      this.renderChild(row)
      this.$('#entries').append(row.el)

  renderNewEntry: (entry) ->
    row = new Ledger.Views.EntryItem({model: entry})
    this.renderChild(row)
    this.$('#entries').prepend(row.el)

  addEntry: ->
    this.entry = new Ledger.Models.Entry
      float_amount: $('#entry_float_amount').val()
      description: $('#entry_description').val()
      account_id: this.model.get('id')
    this.entry.save({}, {success: this.entryAdded, error: this.onError})
    false

  entryAdded: (model, resp, options) ->
    $('#entry_float_amount').val('')
    $('#entry_description').val('')
    this.entry.set(resp)
    this.entry.set
      account: this.model

  onError: ->
    alert 'There was an error.'

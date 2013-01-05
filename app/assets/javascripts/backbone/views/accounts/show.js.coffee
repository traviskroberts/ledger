class Ledger.Views.AccountShow extends Support.CompositeView

  initialize: ->
    _.bindAll this, 'render', 'entryAdded'
    this.entry = new Ledger.Models.Entry
    this.model.bind('add:entries', this.render);

  events:
    'click #add-entry' : 'addEntry'

  render: ->
    template = JST['backbone/templates/accounts/show']({account: this.model.toJSON()})
    this.$el.html(template)
    this.renderEntries()
    this

  renderEntries: ->
    this.model.get('entries').each (entry) =>
      row = new Ledger.Views.EntryItem({model: entry})
      this.renderChild(row)
      this.$('#entries').append(row.el)

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
    this.model.set
      dollar_balance: resp.account_balance
    this.entry.set(resp.entry)
    this.entry.set
      account: this.model

  onError: ->
    alert 'There was an error adding the entry.'

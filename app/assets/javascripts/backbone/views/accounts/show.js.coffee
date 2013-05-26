class Ledger.Views.AccountShow extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'renderEntries', 'validateEntryForm', 'addEntry', 'entryAdded'

    unless @model?
      @model = new Ledger.Models.Account({url: options.url})
      @model.fetch()

    @model.bind 'add:entries', @render
    @model.bind 'remove:entries', @render
    @model.bind 'change', @render
    @model.bind 'sync', @render

    if @model.get('entries').length == 0
      @entries = new Ledger.Collections.Entries
    else
      @entries = @model.get('entries')

    @entries.paginator_core.url = '/api/accounts/' + @model.get('url') + '/entries'
    @entries.bind 'sync', @renderEntries

    if @entries.length == 0
      @model.set('entries': @entries)
      @entries.fetch()

  events:
    'submit .new-entry' : 'addEntry'

  render: ->
    template = JST['backbone/templates/accounts/show']({account: @model.toJSON()})
    @$el.html(template)
    @validateEntryForm()
    if @entries.length > 0
      @renderEntries()
    @

  renderEntries: ->
    @entries.sort()
    @$('#entries').html('')
    row = new Ledger.Views.EntryIndex({collection: @entries, account: @model})
    @renderChild(row)
    @$('#entries').append(row.el)

  validateEntryForm: ->
    @$('form').validate
      groups:
        entry_fields: "entry_float_amount entry_description"

  addEntry: ->
    if @$('form').valid()
      @entry = new Ledger.Models.Entry
        float_amount: $('#entry_float_amount').val()
        description: $('#entry_description').val()
        account_id: @model.get('id')
      @entry.url = '/api/accounts/' + @model.get('url') + '/entries'
      @entry.save({}, {success: @entryAdded, error: @onError})
    false

  entryAdded: (model, resp, options) ->
    $('#entry_float_amount').val('')
    $('#entry_description').val('')
    @model.set
      dollar_balance: resp.account_balance
    @entry.set(resp.entry)
    @entry.set
      account: @model

  onError: ->
    alert 'There was an error adding the entry.'

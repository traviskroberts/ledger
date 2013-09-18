class Ledger.Views.AccountShow extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'renderEntries', 'setupAutocomplete', 'validateEntryForm', 'addEntry', 'entryAdded'
    @autocompleteStarted = false

    unless @model?
      @model = new Ledger.Models.Account({url: options.url})
      @model.fetch()

    @bindTo @model, 'add:entries', @renderEntries
    @bindTo @model, 'remove:entries', @renderEntries
    @bindTo @model, 'change', @render
    @bindTo @model, 'sync', @render

    if @model.get('entries').length == 0
      @entries = new Ledger.Collections.Entries
    else
      @entries = @model.get('entries')

    @entries.paginator_core.url = '/api/accounts/' + @model.get('url') + '/entries'
    @bindTo @entries, 'sync', @renderEntries

    if @entries.length == 0
      @model.set('entries': @entries)
      @entries.fetch()

  events:
    'submit .new-entry': 'addEntry'

  render: ->
    template = JST['backbone/templates/accounts/show']({account: @model.toJSON()})
    @$el.html(template)
    @validateEntryForm()
    if @entries.length > 0
      @renderEntries()
    @$('#entry_float_amount').focus() unless Ledger.isMobile()
    @setupAutocomplete()
    @

  renderEntries: ->
    @entries.sort()
    @$('#entries').html('')
    row = new Ledger.Views.EntryIndex({collection: @entries, account: @model})
    @renderChild(row)
    @$('#entries').append(row.el)

  setupAutocomplete: ->
    if @$('#entry_description').length
      request_url = @entries.url() + '/values'
      @$('#entry_description').autocomplete
        minLength: 2
        source: (req, resp) ->
          $.ajax
            url: request_url
            dataType: 'json'
            data:
              term: req.term
            success: (data) ->
              resp(data.values)

  validateEntryForm: ->
    @$('form').validate
      onfocusout: false
      onkeyup: false
      onclick: false
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

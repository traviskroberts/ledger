class Ledger.Views.EntryItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .edit-entry'       : 'editEntry'
    'click .cancel-edit'      : 'render'
    'click .delete-entry'     : 'deleteEntry'
    'submit .entry-edit-form' : 'updateEntry'

  initialize: (options) ->
    _.bindAll @, 'render', 'editEntry', 'updateEntry', 'updated', 'deleteEntry', 'onDelete'
    @account = options.account
    @model.urlRoot = '/api/accounts/' + @account.get('url') + '/entries'

  render: (e) ->
    e.preventDefault() if e
    @$el.html(JST['backbone/templates/entries/item']({entry: @model.toJSON(), account: @account.toJSON()}))
    @

  editEntry: (e) ->
    @$el.html(JST['backbone/templates/entries/edit']({entry: @model.toJSON(), account: @account.toJSON()}))
    if $(e.currentTarget).attr('data-field') == 'description'
      @$el.find('.entry-description-field').focus()
    else if $(e.currentTarget).attr('data-field') == 'date'
      @$el.find('.entry-date-field').focus()
    else
      @$el.find('.entry-amount-field').focus()

  updateEntry: (e) ->
    e.preventDefault()

    # need to set this when adding a new entry for some reason?
    @model.url = '/api/accounts/' + @account.get('url') + '/entries/' + @model.get('id')

    desc = @$el.find('.entry-description-field').val()
    form_date = @$el.find('.entry-date-field').val()
    date = moment(form_date).format('YYYY-MM-DD')
    amt = @$el.find('.entry-amount-field').val()

    @model.save({description: desc, date: date, float_amount: amt}, success: @updated, error: @onError)

  updated: (model, resp, options) ->
    @model.set
      classification: resp.entry.classification
      description: resp.entry.description
      formatted_date: resp.entry.formatted_date
      timestamp: resp.entry.timestamp
      formatted_amount: resp.entry.formatted_amount
      form_amount_value: resp.entry.form_amount_value
    @account.set(dollar_balance: resp.account_balance)

  onError: ->
    alert 'There was an error updating the entry.'

  deleteEntry: (e) ->
    e.preventDefault()
    @model.destroy(success: @onDelete)

  onDelete: (model, resp, options) ->
    @account.set(dollar_balance: resp.balance)

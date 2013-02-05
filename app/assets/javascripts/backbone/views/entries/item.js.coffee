class Ledger.Views.EntryItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .edit-entry'       : 'editEntry'
    'click .cancel-edit'      : 'render'
    'click .delete-entry'     : 'deleteEntry'
    'submit .entry-edit-form' : 'updateEntry'

  initialize: (options) ->
    _.bindAll this, 'render', 'updateEntry', 'updated', 'deleteEntry', 'onDelete'
    this.account = options.account
    this.model.urlRoot = '/api/accounts/' + this.account.get('url') + '/entries'

  render: (e) ->
    e.preventDefault() if e
    account = this.model.get('account')
    this.$el.html(JST['backbone/templates/entries/item']({entry: this.model.toJSON(), account: account.toJSON()}))
    this

  editEntry: (e) ->
    account = this.model.get('account')
    this.$el.html(JST['backbone/templates/entries/edit']({entry: this.model.toJSON(), account: account.toJSON()}))
    if $(e.currentTarget).attr('data-field') == 'description'
      this.$el.find('.entry-description-field').focus()
    else if $(e.currentTarget).attr('data-field') == 'date'
      this.$el.find('.entry-date-field').focus()
    else
      this.$el.find('.entry-amount-field').focus()

  updateEntry: (e) ->
    e.preventDefault()

    # need to set this when adding a new entry for some reason?
    this.model.url = '/api/accounts/' + this.account.get('url') + '/entries/' + this.model.get('id')

    desc = this.$el.find('.entry-description-field').val()
    form_date = this.$el.find('.entry-date-field').val()
    date = moment(form_date).format('YYYY-MM-DD')
    amt = this.$el.find('.entry-amount-field').val()

    this.model.save({description: desc, date: date, float_amount: amt}, success: this.updated, error: this.onError)

  updated: (model, resp, options) ->
    this.model.set
      classification: resp.entry.classification
      description: resp.entry.description
      formatted_date: resp.entry.formatted_date
      timestamp: resp.entry.timestamp
      formatted_amount: resp.entry.formatted_amount
      form_amount_value: resp.entry.form_amount_value
    this.account.set(dollar_balance: resp.account_balance)

  onError: ->
    alert 'There was an error updating the entry.'

  deleteEntry: (e) ->
    e.preventDefault()
    this.model.destroy(success: this.onDelete)

  onDelete: (model, resp, options) ->
    this.account.set(dollar_balance: resp.balance)

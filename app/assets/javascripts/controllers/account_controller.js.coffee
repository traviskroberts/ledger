Ledger.AccountsIndexController = Ember.ObjectController.extend
  destroyRecord: (acct) ->
    acct.deleteRecord()
    @store.commit()

Ledger.AccountsNewController = Ember.ObjectController.extend
  startEditing: ->
    # create a new record on a local transaction
    @transaction = @get('store').transaction()
    @set('content', @transaction.createRecord(Ledger.Account, {}))

  stopEditing: ->
    # rollback the local transaction if it hasn't already been cleared
    if @transaction
      @transaction.rollback()
      @transaction = null

  save: ->
    # commit and then clear the local transaction
    @transaction.commit()
    @transaction = null

  transitionAfterSave: (->
    # when creating new records, it's necessary to wait for the record to be assigned
    # an id before we can transition to its route (which depends on its id)
    if @get('content.id')
      @transitionToRoute('accounts')
  ).observes('content.id')

  cancel: ->
    @stopEditing()
    @transitionToRoute('accounts')

Ledger.AccountsEditController = Ember.ObjectController.extend
  save: ->
    @get('store').commit()
    @content.one 'didUpdate', =>
      @transitionToRoute('accounts')

  cancel: ->
    if @content.isDirty
      @content.rollback()
    @transitionToRoute('accounts')

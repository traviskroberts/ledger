Ledger.MyAccountController = Ember.ObjectController.extend
  save: ->
    @store.commit()
    @transitionToRoute 'accounts'

  cancel: ->
    if @content.isDirty
      @content.rollback()
    @transitionToRoute 'accounts'

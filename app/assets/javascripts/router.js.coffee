Ember.Router.reopen
  location: 'history'

Ledger.Router.map (match) ->
  @route 'sign_in', path: '/sign-in'
  @route 'sign_out', path: '/sign-out'
  @route 'register'
  @route 'my_account', path: '/my-account'
  @resource 'accounts', ->
    @route 'new', path: '/new'
    @route 'edit', path: '/:account_id/edit'
    @route 'sharing', path: '/:account_id/sharing'
  @resource 'account', path: '/account/:account_id'


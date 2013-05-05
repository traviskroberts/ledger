Ember.Router.reopen
  location: 'history'

Ledger.Router.map (match)->
  @route 'sign_in', path: '/sign-in'
  @route 'sign_out', path: '/sign-out'
  @route 'register', path: '/register'
  @resource 'accounts', ->
    @route 'new', path: 'new'
    @route 'edit', path: ':url/edit'
    @route 'sharing', path: ':url/sharing'
  @resource 'account', path: '/accounts/:url'


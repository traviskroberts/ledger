Ledger.Router.reopen
  location: 'history'

Ledger.Router.map ->
  @route 'sign_in', path: '/sign-in'
  @route 'sign_out', path: '/sign-out'
  @route 'register'
  # @route 'my_account', path: '/my-account'
  @resource 'accounts', ->
    @route 'new', path: '/new'
    @route 'edit', path: '/:url/edit'
    @route 'sharing', path: '/:url/sharing'
  @resource 'account', path: '/account/:url'

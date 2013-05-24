Ledger.Auth = Ember.Auth.create
  userModel: 'Ledger.User'
  signInEndPoint: '/api/user_session'
  signOutEndPoint: '/api/user_session'

  tokenKey: 'auth_token'
  tokenIdKey: 'user_id'

  modules: ['emberData', 'rememberable', 'authRedirectable', 'actionRedirectable']
  rememberable:
    tokenKey: 'remember_token'
    period: 14
    autoRecall: true
  # authRedirectable:
  #   route: 'sign_in'
  actionRedirectable:
    signInRoute: 'accounts'
    signOutRoute: 'sign_in'

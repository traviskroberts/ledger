Ledger.Auth = Ember.Auth.create
  signInEndPoint: '/api/user_session'
  signOutEndPoint: '/api/user_session'
  tokenKey: 'auth_token'
  tokenIdKey: 'user_id'
  tokenLocation: 'param'
  userModel: 'Ledger.User'
  sessionAdapter: 'cookie'
  modules: ['emberData', 'rememberable', 'authRedirectable']
  rememberable:
    tokenKey: 'remember_token'
    period: 365
    autoRecall: true
  authRedirectable:
    route: 'sign_in'

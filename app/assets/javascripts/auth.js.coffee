Ledger.Auth = Ember.Auth.create
  userModel: 'Ledger.User'
  signInEndPoint: '/api/user_session'
  signOutEndPoint: '/api/user_session'

  tokenKey: 'auth_token'
  tokenIdKey: 'user_id'

  sessionAdapter: 'cookie'

  modules: ['emberData', 'rememberable', 'authRedirectable', 'actionRedirectable']
  rememberable:
    tokenKey: 'remember_token'
    period: 365
    autoRecall: true
  authRedirectable:
    route: 'sign_in'
  actionRedirectable:
    signInRoute: 'accounts'
    signOutRoute: 'sign_in'

# retrieve saved authentication
Ledger.Auth.get('module.rememberable').recall()

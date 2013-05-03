Ledger.SignInController = Ember.ObjectController.extend
  email: null
  password: null
  remember_me: true

  signIn: ->
    Ledger.Auth.signIn
      data:
        email:    @get 'email'
        password: @get 'password'
        remember_me: @get 'remember_me'

class Ledger.Views.UserLogin extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render'

  events:
    'submit form' : 'authenticate'

  render: ->
    template = JST['backbone/templates/users/login']
    @$el.html(template)
    @

  authenticate: (e) ->
    e.preventDefault()
    @$el.find('.btn-primary').button('loading')

    login_params = {
      user_session: {
        email       : $('#login_email').val()
        password    : $('#login_password').val()
        remember_me : $('#login_remember_me').prop('checked')
      }
    }

    $.ajax
      url: '/api/user_session'
      type: 'post'
      dataType: 'json'
      data: login_params
      success: (data) ->
        console.log 'Success!'
      error: (xhr, status, errorText) ->
        console.log 'Error:', errorText
    # if failure, show errors
    # if success, redirect to accounts

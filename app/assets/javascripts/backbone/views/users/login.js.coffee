class Ledger.Views.UserLogin extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'authenticate', 'onSuccess', 'onError'

  events:
    'submit form' : 'authenticate'

  render: ->
    template = JST['backbone/templates/users/login']
    @$el.html(template)
    @

  authenticate: (e) ->
    e.preventDefault()
    @$el.find('.alert').remove()
    @$el.find('.btn-primary').attr('disabled', 'disabled')

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
      success: @onSuccess
      error: @onError

  onSuccess: (data) ->
    @model.set(data)
    template = JST['backbone/templates/nav/authenticated']({user: @model.toJSON()})
    $('#main-nav').html(template)
    Backbone.history.navigate('accounts', true)

  onError: (xhr, status, errorText) ->
    @$el.find('.btn-primary').attr('disabled', false)
    data = JSON.parse(xhr.responseText)
    template = JST['backbone/templates/shared/validation_errors']({errors: data.errors})
    @$el.find('form').prepend(template)

class Ledger.Views.UserNew extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'save', 'onSuccess', 'onError'

  events:
    'submit form': 'save'

  render: ->
    template = JST['backbone/templates/users/new']({user: @model.toJSON()})
    @$el.html(template)
    @

  save: (e) ->
    e.preventDefault()
    @$el.find('.alert').remove()
    @$el.find('.btn-primary').attr('disabled', 'disabled')

    params = {
      user: {
        name                  : $('#user_name').val()
        email                 : $('#user_email').val()
        password              : $('#user_password').val()
        password_confirmation : $('#user_password_confirmation').val()
      }
    }

    $.ajax
      url: '/api/users'
      type: 'post'
      dataType: 'json'
      data: params
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

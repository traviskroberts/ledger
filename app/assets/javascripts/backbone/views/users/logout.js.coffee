class Ledger.Views.UserLogout extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'logUserOut', 'onComplete'
    @logUserOut()

  logUserOut: ->
    $.ajax
      url: '/api/user_session'
      type: 'post'
      dataType: 'json'
      data:
        _method: 'delete'
      complete: @onComplete

  onComplete: ->
    @model.clear()
    template = JST['backbone/templates/nav/unauthenticated']
    $('#main-nav').html(template)
    Backbone.history.navigate('login', true)

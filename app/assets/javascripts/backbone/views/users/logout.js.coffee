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
    # all logout logic is handled in router
    Backbone.history.navigate('login', true)

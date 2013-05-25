class Ledger.Views.UserEdit extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render'

  render: ->
    template = JST['backbone/templates/users/edit']
    @$el.html(template)
    @

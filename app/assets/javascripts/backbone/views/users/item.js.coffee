class Ledger.Views.UserItem extends Support.CompositeView
  tagName: 'tr'

  events:
    'click .delete' : 'deleteUser'

  initialize: ->
    _.bindAll @, 'render', 'deleteUser'

  render: ->
    template = JST['backbone/templates/users/item']({user: @model.toJSON()})
    @$el.html(template)
    @

  deleteUser: (e) ->
    e.preventDefault()
    @model.destroy
      error: ->
        alert 'That user could not be deleted.'

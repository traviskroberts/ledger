class Ledger.Views.InvitationItem extends Support.CompositeView
  className: 'li'

  events:
    'click .delete' : 'deleteInvitation'

  initialize: ->
    _.bindAll @, 'render', 'deleteInvitation'
    @model.url = '/api/accounts/' + @model.get('account').get('url') + '/invitations/' + @model.get('id')

  render: ->
    @$el.html(JST['backbone/templates/invitations/item'](invitation: @model.toJSON()))
    @

  deleteInvitation: (e) ->
    e.preventDefault()
    @model.destroy
      error: ->
        alert 'That invitation could not be removed.'

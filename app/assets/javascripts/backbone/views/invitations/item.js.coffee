class Ledger.Views.InvitationItem extends Support.CompositeView
  className: 'li'

  events:
    'click .delete' : 'deleteInvitation'

  initialize: ->
    _.bindAll this, 'render'
    this.model.url = '/api/accounts/' + this.model.get('account').get('url') + '/invitations/' + this.model.get('id')

  render: ->
    this.$el.html(JST['backbone/templates/invitations/item'](invitation: this.model.toJSON()))
    this

  deleteInvitation: (e) ->
    e.preventDefault()
    this.model.destroy
      error: ->
        alert 'That invitation could not be removed.'

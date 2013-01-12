class Ledger.Views.InvitationsIndex extends Support.CompositeView

  initialize: (options) ->
    _.bindAll this, 'render', 'renderInvitations', 'save', 'saved'

    this.account = options.account
    if this.account.get('invitations').length == 0
      this.collection = new Ledger.Collections.Invitations
    else
      this.collection = this.account.get('invitations')

    this.collection.url = '/api/accounts/' + this.account.get('url') + '/invitations'
    this.collection.bind 'sync', this.render
    this.collection.bind 'change', this.render
    this.collection.bind 'remove', this.render

    if this.collection.length == 0
      this.account.set('invitations': this.collection)
      this.collection.fetch()

  events:
    'submit form'   : 'save'

  render: ->
    template = JST['backbone/templates/invitations/index']({account: this.account.toJSON(), invitations: this.collection.toJSON()})
    this.$el.html(template)
    if this.collection.length > 0
      this.renderInvitations()
    this

  renderInvitations: ->
    this.collection.each (invitation) =>
      row = new Ledger.Views.InvitationItem({model: invitation})
      this.renderChild(row)
      this.$('#invitations-list').append(row.el)

  save: (e) ->
    e.preventDefault()
    if this.$('form').valid()
      this.model = new Ledger.Models.Invitation
      this.model.urlRoot = '/api/accounts/' + this.account.get('url') + '/invitations'
      this.model.set
        email: $('#invitation_email').val()
      this.model.save({}, success: this.saved, error: this.onError)

  saved: (model, resp, options) ->
    this.model.set(resp)
    this.model.set({account: this.account})
    this.collection.add(this.model)

  onError: ->
    alert 'There was an error sending the invitation.'

class Ledger.Views.InvitationsIndex extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'renderInvitations', 'save', 'saved'

    @account = options.account
    unless @account?
      @account = new Ledger.Models.Account({url: options.url})
      @bindTo @account, 'sync', @render
      @account.fetch()

    if @account.get('invitations').length == 0
      @collection = new Ledger.Collections.Invitations
    else
      @collection = @account.get('invitations')

    @collection.url = '/api/accounts/' + @account.get('url') + '/invitations'
    @bindTo @collection, 'sync', @render
    @bindTo @collection, 'change', @render
    @bindTo @collection, 'remove', @render

    if @collection.length == 0
      @account.set('invitations': @collection)
      @collection.fetch()

  events:
    'submit form'   : 'save'

  render: ->
    template = JST['backbone/templates/invitations/index']({account: @account.toJSON(), invitations: @collection.toJSON()})
    @$el.html(template)
    if @collection.length > 0
      @renderInvitations()
    @

  renderInvitations: ->
    @collection.each (invitation) =>
      row = new Ledger.Views.InvitationItem({model: invitation})
      @renderChild(row)
      @$('#invitations-list').append(row.el)

  save: (e) ->
    e.preventDefault()
    if @$('form').valid()
      @model = new Ledger.Models.Invitation
      @model.urlRoot = '/api/accounts/' + @account.get('url') + '/invitations'
      @model.set
        email: $('#invitation_email').val()
      @model.save({}, success: @saved, error: @onError)

  saved: (model, resp, options) ->
    @model.set(resp)
    @model.set({account: @account})
    @collection.add(@model)

  onError: ->
    alert 'There was an error sending the invitation.'

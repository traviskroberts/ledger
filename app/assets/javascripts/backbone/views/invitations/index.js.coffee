class Ledger.Views.InvitationItem extends Marionette.ItemView
  tagName: "li"
  template: JST["backbone/templates/invitations/item"]

  ui:
    deleteButton: ".js-delete"

  events:
    "click @ui.deleteButton": "deleteInvitation"

  deleteInvitation: ->
    if confirm("Are you sure you want to revoke this invitation?")
      @model.destroy
        error: ->
          alert "That invitation could not be revoked."

# ==============================================================================

class Ledger.Views.InvitationsEmpty extends Marionette.ItemView
  tagName: "li"
  template: JST["backbone/templates/invitations/empty"]

# ==============================================================================

class Ledger.Views.InvitationsIndex extends Marionette.CompositeView
  template: JST["backbone/templates/invitations/index"]

  emptyView: Ledger.Views.InvitationsEmpty
  childView: Ledger.Views.InvitationItem
  childViewContainer: "#invitations-list"

  ui:
    form: "form"
    submitBtn: ".js-submit"
    email: "#invitation_email"
    backToAccounts: ".js-accounts"

  events:
    "submit @ui.form": "save"
    "click @ui.backToAccounts": "navigateAccounts"

  initialize: (options) ->
    @account = options.account

  serializeData: ->
    data =
      pending_invitations: @collection.length > 0
      account_name: @account.get("name")

  save: (e) ->
    e.preventDefault()
    if @ui.form.valid()
      @ui.submitBtn.button("loading")
      @model = new Ledger.Models.Invitation
      @model.urlRoot = "/api/accounts/" + @account.get("url") + "/invitations"
      @model.set
        email: @ui.email.val()
      @model.save {},
        success: @onSave
        error: @onError

  onSave: (model, resp, options) =>
    @ui.submitBtn.button("reset")
    @ui.email.val("")
    @model.set(resp)
    @model.set({ account: @account })
    @collection.add(@model)

  onError: ->
    @ui.submitBtn.button("reset")
    alert "There was an error sending the invitation."

  navigateAccounts: (e) ->
    e.preventDefault()
    Backbone.history.navigate("accounts", true)

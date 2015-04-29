class Ledger.Views.AccountItem extends Marionette.ItemView
  className: "span12"
  template: JST["backbone/templates/accounts/item"]

  ui:
    showLink: ".js-show"
    editButton: ".js-edit"
    sharingButton: ".js-sharing"
    deleteButton: ".js-delete"

  events:
    "click @ui.showLink": "showAccount"
    "click @ui.editButton" : "editAccount"
    "click @ui.sharingButton" : "sharingSettings"
    "click @ui.deleteButton" : "deleteAccount"

  showAccount: (e) ->
    e.preventDefault()
    url = @model.get("url")
    Backbone.history.navigate("accounts/#{url}", true)

  editAccount: ->
    url = @model.get("url")
    Backbone.history.navigate("accounts/#{url}/edit", true)

  sharingSettings: ->
    url = @model.get("url")
    Backbone.history.navigate("accounts/#{url}/sharing", true)

  deleteAccount: ->
    if confirm("Are you sure you want to delete this account?")
      @model.destroy
        error: ->
          alert "That account could not be removed."

# ==============================================================================

class Ledger.Views.AccountsEmpty extends Marionette.ItemView
  template: JST["backbone/templates/accounts/empty"]

# ==============================================================================

class Ledger.Views.AccountsIndex extends Marionette.CompositeView
  tagName: "span"
  template: JST["backbone/templates/accounts/index"]

  childView: Ledger.Views.AccountItem
  childViewContainer: "#accounts-list"

  ui:
    newAccountButton: "#js-new-account"

  events:
    "click @ui.newAccountButton": "newAccount"

  newAccount: (e) ->
    e.preventDefault()
    Backbone.history.navigate("accounts/new", true)

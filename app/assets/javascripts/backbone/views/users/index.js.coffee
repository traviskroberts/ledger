class Ledger.Views.UserItem extends Marionette.ItemView
  tagName: "tr"
  template: JST["backbone/templates/users/item"]

# ==============================================================================

class Ledger.Views.UsersIndex extends Marionette.CompositeView
  template: JST["backbone/templates/users/index"]

  childView: Ledger.Views.UserItem
  childViewContainer: "#users-list"

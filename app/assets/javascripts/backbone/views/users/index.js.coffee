class Ledger.Views.UsersIndex extends Support.CompositeView

  initialize: (options) ->
    _.bindAll this, 'render', 'renderUsers'

    this.collection = new Ledger.Collections.Users
    this.collection.bind 'sync', this.render
    this.collection.bind 'remove', this.render
    this.collection.fetch()

  render: ->
    template = JST['backbone/templates/users/index']
    this.$el.html(template)
    if this.collection.length > 0
      this.renderUsers()
    this

  renderUsers: ->
    this.collection.each (user) =>
      row = new Ledger.Views.UserItem({model: user})
      this.renderChild(row)
      this.$('#users-list').append(row.el)

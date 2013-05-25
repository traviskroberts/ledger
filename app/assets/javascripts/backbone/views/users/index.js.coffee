class Ledger.Views.UsersIndex extends Support.CompositeView

  initialize: (options) ->
    _.bindAll @, 'render', 'renderUsers'

    @collection = new Ledger.Collections.Users
    @collection.bind 'sync', @render
    @collection.bind 'remove', @render
    @collection.fetch()

  render: ->
    template = JST['backbone/templates/users/index']
    @$el.html(template)
    if @collection.length > 0
      @renderUsers()
    @

  renderUsers: ->
    @collection.each (user) =>
      row = new Ledger.Views.UserItem({model: user})
      @renderChild(row)
      @$('#users-list').append(row.el)

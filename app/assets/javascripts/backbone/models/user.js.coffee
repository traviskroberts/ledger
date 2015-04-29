class Ledger.Models.User extends Backbone.Model
  urlRoot: "/api/users"

class Ledger.Collections.Users extends Backbone.Collection
  model: Ledger.Models.User
  url: "/api/users"

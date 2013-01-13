class Ledger.Models.Entry extends Backbone.RelationalModel
  urlRoot: '/api/entries'

Ledger.Models.Entry.setup() # needed for backbone-relational

class Ledger.Collections.Entries extends Backbone.Collection
  model: Ledger.Models.Entry
  url: '/api/entries'

  comparator: (entry) ->
    -entry.get('id')

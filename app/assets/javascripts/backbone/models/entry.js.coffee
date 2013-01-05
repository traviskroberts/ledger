Ledger.Models.Entry = Backbone.RelationalModel.extend
  urlRoot : '/api/entries'

class Ledger.Collections.Entries extends Backbone.Collection
  model: Ledger.Models.Entry
  url: '/api/entries'

  comparator: (entry) ->
    -entry.get('id')

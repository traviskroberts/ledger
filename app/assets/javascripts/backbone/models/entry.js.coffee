Ledger.Models.Entry = Backbone.RelationalModel.extend
  urlRoot : '/entries'

class Ledger.Collections.Entries extends Backbone.Collection
  model: Ledger.Models.Entry
  url: '/entries'

Ledger.Models.Account = Backbone.RelationalModel.extend
  urlRoot : '/accounts'
  idAttribute: 'url'

  relations: [
    type: Backbone.HasMany
    key: 'entries'
    relatedModel: 'Ledger.Models.Entry'
    collectionType: 'Ledger.Collections.Entries'
    reverseRelation:
      key: 'account'
      includeInJSON: 'id'
  ]

class Ledger.Collections.Accounts extends Backbone.Collection
  model: Ledger.Models.Account
  url: '/accounts'

class Ledger.Models.Account extends Backbone.RelationalModel
  urlRoot : "/api/accounts"
  idAttribute: "url"

  relations: [
    {
      type: Backbone.HasMany
      key: "entries"
      relatedModel: "Ledger.Models.Entry"
      collectionType: "Ledger.Collections.Entries"
      reverseRelation:
        key: "account"
        includeInJSON: "id"
    },
    {
      type: Backbone.HasMany
      key: "invitations"
      relatedModel: "Ledger.Models.Invitation"
      collectionType: "Ledger.Collections.Invitations"
      reverseRelation:
        key: "account"
        includeInJSON: "id"
    },
    {
      type: Backbone.HasMany
      key: "recurring_transactions"
      relatedModel: "Ledger.Models.RecurringTransaction"
      collectionType: "Ledger.Collections.RecurringTransactions"
      reverseRelation:
        key: "account"
        includeInJSON: "id"
    }
  ]

Ledger.Models.Account.setup() # needed for backbone-relational

class Ledger.Collections.Accounts extends Backbone.Collection
  model: Ledger.Models.Account
  url: "/api/accounts"

class Ledger.Models.RecurringTransaction extends Backbone.RelationalModel
  urlRoot : '/api/recurring_transactions'

Ledger.Models.RecurringTransaction.setup() # needed for backbone-relational

class Ledger.Collections.RecurringTransactions extends Backbone.Collection
  model: Ledger.Models.RecurringTransaction
  url: '/api/recurring_transactions'

  comparator: (recurring_transaction) ->
    recurring_transaction.get('day')

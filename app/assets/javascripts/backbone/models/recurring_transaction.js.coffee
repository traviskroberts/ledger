Ledger.Models.RecurringTransaction = Backbone.RelationalModel.extend
  urlRoot : '/api/recurring_transactions'

class Ledger.Collections.RecurringTransactions extends Backbone.Collection
  model: Ledger.Models.RecurringTransaction
  url: '/api/recurring_transactions'

  comparator: (recurring_transaction) ->
    recurring_transaction.get('day')

DS.RESTAdapter.reopen
  namespace: 'api'

Ledger.Adapter = DS.RESTAdapter.extend
  bulkCommit: false

# Ledger.Adapter.map 'Ledger.Account',
#   primaryKey: 'url'

Ledger.Store = DS.Store.extend
  revision: 12
  adapter:  Ledger.Adapter.create()

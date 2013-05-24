DS.RESTAdapter.reopen
  namespace: 'api'

Ledger.Adapter = DS.RESTAdapter.extend
  bulkCommit: false

Ledger.Adapter.configure 'plurals',
  entry: 'entries'

Ledger.Adapter.map 'Ledger.Account',
  entries: { embedded: 'always' }

Ledger.Store = DS.Store.extend
  revision: 12
  adapter:  Ledger.Adapter.create()

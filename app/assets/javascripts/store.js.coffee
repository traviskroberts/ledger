DS.RESTAdapter.reopen
  namespace: 'api'

Ledger.Store = DS.Store.extend
  revision: 11
  adapter: DS.RESTAdapter.create()

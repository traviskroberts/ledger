Ledger.Account = DS.Model.extend
  url             : DS.attr()
  name            : DS.attr()
  dollar_balance  : DS.attr()
  initial_balance : DS.attr()
  entries         : DS.hasMany('entry')

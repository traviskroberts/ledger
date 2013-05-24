Ledger.Account = DS.Model.extend
  url             : DS.attr('string')
  name            : DS.attr('string')
  dollar_balance  : DS.attr('string')
  initial_balance : DS.attr('string')
  entries         : DS.hasMany('Ledger.Entry')

Ledger.Account = DS.Model.extend
  url             : DS.attr('string')
  name            : DS.attr('string')
  dollar_balance  : DS.attr('string')
  initial_balance : DS.attr('string')
  user            : DS.belongsTo('Ledger.User')
  entries         : DS.hasMany('Ledger.Entry')

Ledger.Account = DS.Model.extend
  url             : DS.attr('string')
  name            : DS.attr('string')
  dollar_balance  : DS.attr('number')
  user            : DS.belongsTo('Ledger.User')
  entries         : DS.hasMany('Ledger.Entry')

Ledger.User = DS.Model.extend
  name      : DS.attr('string')
  email     : DS.attr('string')
  accounts  : DS.hasMany('Ledger.Account')

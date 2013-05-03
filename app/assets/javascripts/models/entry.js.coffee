Ledger.Entry = DS.Model.extend
  classification    : DS.attr('string')
  description       : DS.attr('string')
  formatted_amount  : DS.attr('string')
  formatted_date    : DS.attr('string')
  timestamp         : DS.attr('number')
  form_amount_val   : DS.attr('number')
  account           : DS.belongsTo('Ledger.Account')

Ledger.Entry = DS.Model.extend
  classification    : DS.attr()
  description       : DS.attr()
  formatted_amount  : DS.attr()
  formatted_date    : DS.attr()
  timestamp         : DS.attr()
  form_amount_val   : DS.attr()
  account           : DS.belongsTo('account')

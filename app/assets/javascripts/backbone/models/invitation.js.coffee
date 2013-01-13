class Ledger.Models.Invitation extends Backbone.RelationalModel
  urlRoot : '/api/invitations'

Ledger.Models.Invitation.setup() # needed for backbone-relational

class Ledger.Collections.Invitations extends Backbone.Collection
  model: Ledger.Models.Invitation
  url: '/api/invitations'

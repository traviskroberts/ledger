Ledger.Models.Invitation = Backbone.RelationalModel.extend
  urlRoot : '/api/invitations'

class Ledger.Collections.Invitations extends Backbone.Collection
  model: Ledger.Models.Invitation
  url: '/api/invitations'

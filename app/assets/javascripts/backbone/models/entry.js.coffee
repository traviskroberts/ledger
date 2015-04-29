class Ledger.Models.Entry extends Backbone.RelationalModel
  urlRoot: ->
    "/api/accounts/#{@get("account_url")}/entries"

Ledger.Models.Entry.setup() # needed for backbone-relational

class Ledger.Collections.Entries extends Backbone.PageableCollection
  model: Ledger.Models.Entry

  state:
    firstPage: 1
    currentPage: 1

  parseRecords: (resp) ->
    @state.totalPages = resp.total_pages
    @state.totalRecords = resp.total_number
    resp.entries

  comparator: (entry) ->
    -entry.get("timestamp")

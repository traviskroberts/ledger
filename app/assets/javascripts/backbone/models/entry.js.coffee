class Ledger.Models.Entry extends Backbone.RelationalModel
  urlRoot: '/api/entries'

Ledger.Models.Entry.setup() # needed for backbone-relational

class Ledger.Collections.Entries extends Backbone.Paginator.requestPager
  model: Ledger.Models.Entry
  paginator_core:
    url: '/api/entries'
    dataType: 'json'
  paginator_ui:
    firstPage: 1
    currentPage: 1
    perPage: 25
  server_api:
    'page': ->
      this.currentPage
  parse: (resp) ->
    this.totalPages = resp.total_pages
    this.totalRecords = resp.total_number
    resp.entries

  comparator: (entry) ->
    -entry.get('id')

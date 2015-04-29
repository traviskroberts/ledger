#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

@Ledger = new Marionette.Application

Ledger.module "Models"
Ledger.module "Collections"
Ledger.module "Views"
Ledger.module "Controllers"
Ledger.module "Routers"

Ledger.addRegions
  header: "#region-header"
  main: "#region-main"

Ledger.addInitializer ->
  @router = new Ledger.Routers.AppRouter

  unless Backbone.history.started
    Backbone.history.start({ pushState: true })
    Backbone.history.started = true

$ ->
  Ledger.start()

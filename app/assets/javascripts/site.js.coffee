window.addEventListener "load", ->
  new FastClick document.body
, false

# handle authentication denied errors
$.ajaxSetup
  statusCode:
    401: ->
      window.location.replace "/login"

$ ->
  if $("#screen-info").length
    win_size = $(window).width()
    $("#screen-info").html(win_size + "px")
    $(window).resize ->
      win_size = $(window).width()
      $("#screen-info").html(win_size + "px")

  if $(".alert-fixed").length
    setTimeout("$('.alert-fixed').slideUp(500)", 5000)

  # datepicker
  $("#region-main").on
    "click": ->
      el = $(this)
      el.datepicker("show").on "changeDate", (ev) ->
        if ev.viewMode == "days"
          el.datepicker("hide")
    "focus": ->
      el = $(this)
      el.datepicker("show").on "changeDate", (ev) ->
        if ev.viewMode == "days"
          el.datepicker("hide")
    ".datepicker"

Handlebars.registerHelper "option_selected", (val1, val2) ->
  ret = ""
  if val1 == val2
    ret = ' selected="selected"'

  new Handlebars.SafeString(ret)

Handlebars.registerHelper "pagination_info", (page, perpage, total) ->
  if page == 1
    start = 1
    end = perpage
  else
    start = ((page - 1) * perpage) + 1
    end = page * perpage

  if end > total
    end = total

  ret = start + " - " + end + " of " + total
  new Handlebars.SafeString(ret)

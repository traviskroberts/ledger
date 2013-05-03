window.addEventListener 'load', ->
  new FastClick document.body
, false

$ ->
  if $("#screen-info").length
    win_size = $(window).width()
    $("#screen-info").html(win_size + 'px')
    $(window).resize ->
      win_size = $(window).width()
      $("#screen-info").html(win_size + 'px')

  if $('.alert-fixed').length
    setTimeout("$('.alert-fixed').slideUp(500)", 5000)

Handlebars.registerHelper 'option_selected', (val1, val2) ->
  ret = ''
  if val1 == val2
    ret = ' selected="selected"'

  new Handlebars.SafeString(ret)

Handlebars.registerHelper 'pagination_info', (page, perpage, total) ->
  if page == 1
    start = 1
    end = perpage
  else
    start = ((page - 1) * perpage) + 1
    end = page * perpage

  if end > total
    end = total

  ret = start + ' - ' + end + ' of ' + total
  new Handlebars.SafeString(ret)

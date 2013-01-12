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

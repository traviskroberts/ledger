$ ->
  Entries.load()

  if $('.alert').length
    setTimeout("$('.alert').slideUp(500)", 5000)


@Entries =
  load: ->
    container = $('#entry-container')
    container.spin('large')
    $.ajax
      url: container.attr('data-url')
      dataType: 'html'
      success: (data) ->
        container.html(data)
        Entries.bindLinks()
      error: ->
        container.spin(false)

  loadPage: (link_element) ->
    $("html, body").animate({ scrollTop: "90px" }, 200)
    container = $('#entry-container')
    container.spin('large')
    container.find('ul').css('opacity', '0.5')
    $.ajax
      url: link_element.href
      dataType: 'html'
      success: (data) ->
        container.html(data)
        Entries.bindLinks()
        $('#entry_float_amount').focus()
      error: ->
        container.spin(false)
        container.find('ul').css('opacity', '1')

  deleteEntry: (link_element) ->
    $.ajax
      url: link_element.href
      type: 'post'
      dataType: 'json'
      data:
        _method: 'delete'
      success: (data) ->
        $(link_element).parents('li').fadeOut(200)
        $('#current-balance').html(data.balance)
      error: ->
        Entries.showOverlayMessage('There was an error deleting the entry.')

  bindLinks: ->
    $('.pagination').on 'click', 'a', (event) ->
      event.preventDefault()
      Entries.loadPage(this)

    $('#entries').on 'click', '.delete-entry', (event) ->
      event.preventDefault()
      Entries.deleteEntry(this)

  showOverlayMessage: (msg) ->
    overlay = '<div class="overlay-message"><div class="interior">' + msg + '</div></div>'
    $('body').append(overlay)
    $('.overlay-message').fadeIn(500)
    autoFade = setTimeout("$('.overlay-message').fadeOut(500)", 3000)
    $('.overlay-message').click ->
      clearTimeout(autoFade)
      $('.overlay-message').fadeOut(500)

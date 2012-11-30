$ ->
  Entries.load()

Entries =
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

  bindLinks: ->
    $('.pagination').on 'click', 'a', (event) ->
      event.preventDefault()
      Entries.loadPage(this)

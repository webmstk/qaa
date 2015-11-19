ready = ->

  $('.search_input .dropdown-menu a').click (e) ->
    e.preventDefault()

    $('.search_input .dropdown-menu li').removeClass('active')
    $(this).parent().addClass('active')

    text = $(this).text()
    model = $(this).data('model')
    $('.search_input input[name=m]').val(model)
    $('.search_input .dropdown-toggle').html(text + '<span class="caret"></span>')

$(document).ready(ready)
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')

    $('#answer-' + answer_id).hide()
    $('#edit_answer_' + answer_id).show()


  $('.edit_answer .cancel').click (e) ->
    e.preventDefault()
    $(this).closest('form').hide()
           .prev().show()


  $('.answer .like').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);

    if(response.id)
      $('#answer-' + response.id + ' .rating').text( response.rating )

      if(response.status == 'success')
        $('#answer-' + response.id + ' .like').addClass('voted')
      else if(response.status == 'vote_canceled')
        $('#answer-' + response.id + ' .dislike').removeClass('voted')      
      else if(response.status == 'forbidden')
        show_popup('Вы не можете голосовать за свой ответ')

  $('.answer .like').bind 'ajax:error', (xhr, status, error) ->
    show_popup(status.responseText)


  $('.answer .dislike').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);

    if(response.id)
      $('#answer-' + response.id + ' .rating').text( response.rating )

      if(response.status == 'success')
        $('#answer-' + response.id + ' .dislike').addClass('voted')
      else if(response.status == 'vote_canceled')
        $('#answer-' + response.id + ' .like').removeClass('voted')
      else if(response.status == 'forbidden')
        show_popup('Вы не можете голосовать за свой ответ')

  $('.answer .dislike').bind 'ajax:error', (xhr, status, error) ->
    show_popup(status.responseText)


  $('#new_answer').bind 'ajax:error', (xhr, status, error) ->
    show_popup('Только зарегистрированные пользователи могут отвечать. <a href="/users/sign_in">Авторизоваться</a>')


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
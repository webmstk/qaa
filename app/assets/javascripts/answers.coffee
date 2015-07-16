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
      rating = parseInt($('#answer-' + response.id + ' .rating').text())
      $('#answer-' + response.id + ' .rating').text( ++rating )

      if(response.status == 'success')
        $('#answer-' + response.id + ' .like').addClass('voted')
      else if(response.status == 'vote_canceled')
        $('#answer-' + response.id + ' .dislike').removeClass('voted')      

  $('.answer .like').bind 'ajax:error', (e, data, status, xhr) ->
    if(xhr == 'Unauthorized ')
      show_popup('Только зарегистрированные пользователи могут голосовать')

  $('.answer .dislike').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    if(response.id)
      rating = parseInt($('#answer-' + response.id + ' .rating').text())
      $('#answer-' + response.id + ' .rating').text( --rating )

      if(response.status == 'success')
        $('#answer-' + response.id + ' .dislike').addClass('voted')
      else if(response.status == 'vote_canceled')
        $('#answer-' + response.id + ' .like').removeClass('voted')

  $('.answer .dislike').bind 'ajax:error', (e, data, status, xhr) ->
    if(xhr == 'Unauthorized ')
      show_popup('Только зарегистрированные пользователи могут голосовать')



$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
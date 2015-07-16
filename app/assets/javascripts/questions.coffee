# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()

    question_id = $(this).data('questionId')

    $('.question').addClass('hidden')
    $('#edit_question_' + question_id).removeClass('hidden')


  $('.edit-question .cancel').click (e) ->
    e.preventDefault()

    $('.edit-question').addClass('hidden')
    $('.question').removeClass('hidden')

  $('.question .like').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);

    if(response.id)
      rating = parseInt($('#question-id-' + response.id + ' .rating').text())
      $('#question-id-' + response.id + ' .rating').text( ++rating )

      if(response.status == 'success')
        $('#question-id-' + response.id + ' .like').addClass('voted')
      else if(response.status == 'vote_canceled')
        $('#question-id-' + response.id + ' .dislike').removeClass('voted')


  $('.question .like').bind 'ajax:error', (e, data, status, xhr) ->
    if(xhr == 'Unauthorized ')
      show_popup('Только зарегистрированные пользователи могут голосовать')

  $('.question .dislike').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    if(response.id)
      rating = parseInt($('#question-id-' + response.id + ' .rating').text())
      $('#question-id-' + response.id + ' .rating').text( --rating )

      if(response.status == 'success')
        $('#question-id-' + response.id + ' .dislike').addClass('voted')
      else if(response.status == 'vote_canceled')
        $('#question-id-' + response.id + ' .like').removeClass('voted')

  $('.question .dislike').bind 'ajax:error', (e, data, status, xhr) ->
    if(xhr == 'Unauthorized ')
      show_popup('Только зарегистрированные пользователи могут голосовать')

  $('#bla').click ->
    $('.modal').modal()
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
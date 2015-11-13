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


  bind_vote_for_question = ->
    $('.question .like').bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText);

      if(response.id)
        $('#question-id-' + response.id + ' .rating').text( response.rating )

        if(response.status == 'success')
          $('#question-id-' + response.id + ' .like').addClass('voted')
        else if(response.status == 'vote_canceled')
          $('#question-id-' + response.id + ' .dislike').removeClass('voted')
        else if(response.status == 'forbidden')
          show_popup('Вы не можете голосовать за свой ответ')

    $('.question .like').bind 'ajax:error', (xhr, status, error) ->
      show_popup(status.responseText)

    $('.question .dislike').bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText);
      
      if(response.id)
        $('#question-id-' + response.id + ' .rating').text( response.rating )

        if(response.status == 'success')
          $('#question-id-' + response.id + ' .dislike').addClass('voted')
        else if(response.status == 'vote_canceled')
          $('#question-id-' + response.id + ' .like').removeClass('voted')
        else if(response.status == 'forbidden')
          show_popup('Вы не можете голосовать за свой ответ')

    $('.question .dislike').bind 'ajax:error', (xhr, status, error) ->
      show_popup(status.responseText)


  bind_vote_for_question()


  PrivatePub.subscribe '/questions/index', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append(HandlebarsTemplates['question'](question))
    bind_vote_for_question()


  $('.question .subscribe-question').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    question_id = $('.question').data('questionId')

    if(response.status == 'subscribed')
      $(this).addClass('subscribed')
             .text('отписаться')
             .attr('href', '/questions/' + question_id + '/unsubscribe')
    else if(response.status == 'unsubscribed')
      $(this).removeClass('subscribed')
             .text('подписаться')
             .attr('href', '/questions/' + question_id + '/subscribe')



$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
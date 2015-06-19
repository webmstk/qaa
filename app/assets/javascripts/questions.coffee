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

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
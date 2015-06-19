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


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
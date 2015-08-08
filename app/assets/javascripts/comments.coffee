ready = ->

  # bindings

  bind_comment_error = ->
    $('.new_comment').bind 'ajax:error', (e, xhr, status, error) ->
      parent = $(this).parent()
      parent.find('.error').remove()

      error = xhr.responseJSON
      if(error)
        parent.prepend('<div class="error alert alert-danger">' + error + '</div>')

  bind_comment_cancel = ->
    $('.new_comment .cancel').click (e) ->
      e.preventDefault()

      $('.add_comment .error').remove()
      $('#comment_body').val('')
      $(this).parent().hide()
      $('.question-detail .add_comment a').show()

  # bind_delete_comment = ->
  #   $('.comment .delete').bind 'ajax:success', (e, data, status, xhr) ->
  #     response = xhr.responseJSON
  #     if(response.id)
  #       $('#comment-id-' + response.id).remove()

  # bind_delete_comment()



  # Add comment

  $('.add_comment a').click (e) ->
    e.preventDefault()
    commentable_id = $(this).data('id')
    commentable_type = $(this).data('type')
    commentable = {id: commentable_id, type: commentable_type}
    $(this).parent().prepend(HandlebarsTemplates['add_comment'](commentable));
    bind_comment_error()
    bind_comment_cancel()


  # Comet

  question_id = $('.question-detail').data('questionId')
  channel = '/question/' + question_id + '/comments'
  PrivatePub.subscribe channel, (data, channel) ->
    comment = $.parseJSON(data['comment'])

    if(comment['action'] == 'delete')
      $('#comment-id-' + comment['id']).remove()
    else
      if comment['commentable_type'] == 'Question'
        $('.add_comment .error').remove()

        $('.question-detail .comments').append(HandlebarsTemplates['comment'](comment))
        $('#comment_body').val('')
        $('.new_comment').hide()
        $('.question-detail .add_comment a').show()
      else
        answer_id = comment['commentable_id']
        $('#answer-' + answer_id + ' .comments').append(HandlebarsTemplates['comment'](comment))
        $('.new_comment').hide()
        # alert(comment['commentable_type'])






$(document).ready(ready)

class CommentsController < ApplicationController
  before_action :authenticate_user!
  #before_action :load_commentable

  # authorize_resource

  def create
    authorize! :create, Comment

    commentable = load_commentable
    question_id = get_question_id(commentable)
    @comment = commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        # интересно, можно ли реализовать обработку json: @comment, если thin не запущен
        # format.json { render json: @comment }
        PrivatePub.publish_to "/question/#{question_id}/comments", comment: @comment.to_json
        format.json { render json: {} }
      else
        format.json { render json: @comment.errors.full_messages, root: false, status: 418 }
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize! :destroy, comment

    respond_to do |format|
      if comment.user_id == current_user.id
        commentable = load_commentable_by_comment(comment)
        question_id = get_question_id(commentable)

        comment.destroy
        PrivatePub.publish_to "/question/#{question_id}/comments", comment: { id: comment.id, action: :delete }.to_json
        # format.json { render json: { id: comment.id } }
        format.json { render json: {} }
      else
        format.json { render json: { status: 'error' } }
      end
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    # этот способ подсмотрен с Railscasts
    def load_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

    def load_commentable_by_comment(comment)
      comment.commentable_type.constantize.find(comment.commentable_id)
    end

    def get_question_id(commentable)
      if commentable.class.name == 'Answer'
        commentable.question_id
      else
        commentable.id
      end
    end
end

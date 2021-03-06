class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update, :subscribe, :unsubscribe]
  before_action :build_answer, only: :show
  before_action :build_comment, only: :show

  respond_to :html, :js
  respond_to :json, only: [:subscribe, :unsubscribe]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def create
    respond_with(@question = Question.create(question_params.merge({user_id: current_user.id})))
  end

  def destroy
    if @question.user_id == current_user.id
      respond_with(@question.destroy)
    else
      redirect_to @question, notice: 'Вы не можете удалить чужой вопрос'
    end
  end

  def subscribe
    current_user.subscribe_to(@question)
    render json: {status: :subscribed}
  end

  def unsubscribe
    current_user.unsubscribe_from(@question)
    render json: {status: :unsubscribed}
  end

  private

    def load_question
      id = params[:question_id] ? params[:question_id] : params[:id]
      @question = Question.find(id)
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
    end

    def build_answer
      @answer = Answer.new
    end

    def build_comment
      @comment = Comment.new
    end
end

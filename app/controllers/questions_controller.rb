class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sorted
    @comment = Comment.new
    @comments = @question.comments.sorted
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def update
    @question.update(question_params)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Ваш вопрос успешно создан.'
      PrivatePub.publish_to '/questions/index', question: @question.to_json
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      redirect_to questions_path, notice: 'Вопрос успешно удалён'
    else
      redirect_to @question, notice: 'Вы не можете удалить чужой вопрос'
    end
  end

  private

    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
    end
end

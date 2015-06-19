class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.order(best: :desc, created_at: :asc)
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def update
    @question.update(question_params)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Ваш вопрос успешно создан.'
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
      params.require(:question).permit(:title, :body)
    end
end

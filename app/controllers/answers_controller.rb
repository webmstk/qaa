class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :best]
  before_action :load_answer, only: [:update, :destroy]
  before_action :load_best_answer, only: :best
  before_action :load_question, only: :update

  respond_to :html, :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge({user_id: current_user.id})))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy) if @answer.user_id == current_user.id
  end

  def best
    if @answer.question.user_id == current_user.id
      @answer.toggle_best
      respond_with @answer.reload
    end
  end

  private

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def load_best_answer
      @answer = Answer.find(params[:answer_id])
    end

    def load_question
      @question = @answer.question
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
    end
end

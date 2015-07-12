class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update_attributes(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
    end
  end

  def best
    @answer = Answer.find(params[:answer_id])
    if @answer.question.user_id == current_user.id
      @answer.toggle_best
      @answer.reload
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
    end
end

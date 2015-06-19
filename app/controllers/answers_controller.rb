class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
=begin
    if @answer.save
      redirect_to @question
    else
      messages = @answer.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join
      flash[:notice] = "Не удалось сохранить ответ: <ul>#{messages}</ul>"
      @answers = @question.answers
      @answers.reload
      render 'questions/show'
    end
=end
  end
  
  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user_id == current_user.id
      flash[:notice] = @answer.destroy ? 'Ответ успешно удалён' : 'Не получилось
                                                                  удалить ответ'
    else
      flash[:notice] = 'Нельзя удалить чужой ответ'
    end
    
    redirect_to question_path(id: params[:question_id])
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end

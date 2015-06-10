require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      sign_in_user
      let(:answer) { question.answers.create(attributes_for(:answer)) }

      it 'save answer to the database' do
        expect do
          post :create, question_id: question.id, answer: attributes_for(:answer)
        end.to change(question.answers, :count).by(1)
      end
      
      it 'belongs to user' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end

      it 'redirects to :show view of requested question' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      
      it 'does not save answer to the database' do
        expect do
          post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        end.to_not change(Answer, :count)
      end

      it 're-render :create view' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template 'questions/show'
      end
    end
  end
  
  
  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    sign_in_user
    before { answer.update_attribute(:user_id, @user.id) }
  
    context 'own answer' do
      before { answer }
      
      it 'removes answer from the database' do
        expect do
          delete :destroy, question_id: question, id: answer
        end.to change(Answer, :count).by(-1)
      end
      
      it 're-renders question :show view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end
    
    context 'somebody\'s answer' do
      let(:another_user) { create(:user) }
      let(:another_user_answer) do
        create(:answer, user: another_user, question: question)
      end
      before { another_user_answer }
    
      it 'does not remove question from the database' do
        expect do
          delete :destroy, question_id: question, id: another_user_answer
        end.not_to change(Answer, :count)
      end
      
      it 'rerenders question :show view' do
        delete :destroy, question_id: question, id: another_user_answer
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end

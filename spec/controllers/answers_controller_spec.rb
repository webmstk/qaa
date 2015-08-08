require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }

  describe 'POST #create' do
    sign_in_user
    
    context 'with valid attributes' do
      let(:answer) { question.answers.create(attributes_for(:answer)) }

      it 'save answer to the database' do
        expect do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'belongs to user' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end

      it 'redirects to :show view of requested question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to the database' do
        expect do
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        end.to_not change(Answer, :count)
      end

      it 're-render :create view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end


  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }
    sign_in_user
    before { answer.update_attribute(:user_id, @user.id) }

    context 'own answer' do
      it 'removes answer from the database' do
        expect do
          delete :destroy, question_id: question, id: answer, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'renders :destroy view' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
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
          delete :destroy, question_id: question, id: another_user_answer, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders :destroy view' do
        delete :destroy, question_id: question, id: another_user_answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end


  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }
    sign_in_user

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'edited body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'edited body'
    end

    it 'renders update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end


  describe 'GET #best' do
    let(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:best_answer, question: question) }
    sign_in_user
    before { question.update_attribute(:user_id, @user.id) }

    it 'removes best mark form answer if it was best' do
      xhr :get, :best, answer_id: best_answer, format: :js
      best_answer.reload
      expect(best_answer.best).to eq false
    end

    describe "another's user question" do
      let(:another_question) { create(:question) }
      let(:another_answer) { create(:answer, question: another_question) }

      it 'does not add best mark' do
        xhr :get, :best, answer_id: another_answer, question_id: another_question, format: :js

        another_answer.reload
        expect(another_answer.best).to eq false
      end
    end

    describe 'adds best mark to answer' do
      before { xhr :get, :best, answer_id: answer, question_id: question, format: :js }

      it 'assigns the requested answer_id to @answer_id' do
        expect(assigns(:answer)).to eq answer
      end

      it 'makes the requested answer best one' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'keeps only one best answer at time' do
        answer.reload
        best_answer.reload

        expect(answer.best).to eq true
        expect(best_answer.best).to eq false
      end

      it 'renders :best view' do
        expect(response).to render_template :best
      end
    end
  end

end

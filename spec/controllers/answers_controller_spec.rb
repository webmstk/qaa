require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      let(:answer) { question.answers.create(attributes_for(:answer)) }

      it 'save answer to the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to :show view of requested question' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        redirect_to question_path(question.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-render :create view' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template('questions/show')
      end
    end
  end
end

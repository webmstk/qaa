require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    before { get :index }

    it 'loads all of the questions into @questions' do
      questions = create_list(:question, 2)

      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    let(:user) { create :user }
    let(:answer1) { create(:answer, question: question) }
    let(:answer2) { create(:answer, question: question) }
    let(:comment1) { create(:comment, commentable: question, user: user) }
    let(:comment2) { create(:comment, commentable: question, user: user) }
    let!(:comment3) { create(:comment, commentable: answer1, user: user) }
    let!(:comment4) { create(:comment, commentable: answer1, user: user) }
    
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    # it 'assigns all of the answers of requested question to @answers' do
    #   expect(assigns(:answers)).to match_array([answer1, answer2])
    # end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    # it 'assigns all comments of the requested question to @comments' do
    #   expect(assigns(:comments)).to match_array([comment1, comment2])
    # end

    it 'assigns a new Comment to @comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    # it 'builds new attachment for answer' do
    #   expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    # end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end


  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    # it 'builds new attachment for question' do
    #   expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    # end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect do
          post :create, question: attributes_for(:question)
        end.to change(Question, :count).by(1)
      end

      it 'belongs to user' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user_id).to eq subject.current_user.id
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, question: attributes_for(:invalid_question)
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders :update view' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'question title'
        expect(question.body).to eq 'question body'
      end

      it 'renders :update view' do
        expect(response).to render_template :update
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user

    context "own question" do
      before { question.update_attribute(:user, @user) }

      it 'deletes question' do
        expect { delete :destroy, id: question}.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'somebody\'s else question' do
      let(:another_user) { create(:user) }
      let(:another_user_question) { create(:question, user: another_user) }

      it 'doesn\'t delete question' do
        another_user_question
        expect do
          delete :destroy, id: another_user_question
        end.not_to change(Question, :count)
      end

      it 'redirects to show view' do
        delete :destroy, id: another_user_question
        expect(response).to redirect_to question_path(another_user_question)
      end
    end
  end

end

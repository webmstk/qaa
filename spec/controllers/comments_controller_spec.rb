require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create(:answer, question: question) }
  let(:comment) { answer.comments.build(attributes_for(:comment)) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'should create new Comment' do
        expect do
          post :create, answer_id: answer, comment: attributes_for(:comment), format: :json
        end.to change(answer.comments, :count).by(1)
      end

      
      # этот тест получается не нужен??? не знаю, как протестировать что контроллер передал управление private_pub

      # it 'should render json comment' do
      #   post :create, answer_id: answer, comment: attributes_for(:comment), format: :json
        
      #   comment_json = JSON.parse(response.body)
      #   comment_db = JSON.parse(Comment.last.to_json)
        
      #   expect(comment_json).to eq comment_db
      # end
    end

    context 'with invalid attributes' do
      let(:invalid_comment) { answer.comments.build(attributes_for(:invalid_comment)) }
      before { invalid_comment.user = @user }

      it 'should not create new Comment' do
        expect do
          post :create, answer_id: answer, comment: attributes_for(:invalid_comment), format: :json
        end.to_not change(answer.comments, :count)
      end

      it 'should render json error' do
        post :create, answer_id: answer, comment: attributes_for(:invalid_comment), format: :json

        comment_json = JSON.parse(response.body)
        invalid_comment.save

        expect(comment_json).to eq invalid_comment.errors.full_messages
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before do
      comment.user = @user
      comment.save
    end

    context 'own comment' do
      it 'should delete Comment from database' do
        expect do
          delete :destroy, id: comment.id, format: :json
        end.to change(answer.comments, :count).by(-1)
      end

      # it 'renders id of deleted comment' do
      #   delete :destroy, id: comment.id, format: :json

      #   json = JSON.parse(response.body)
      #   expect(json['id']).to eq comment.id
      # end
    end

    context "somebody's comment" do
      before do
        another_user = create(:user)
        comment.update_attribute(:user_id, another_user.id)
      end

      it 'should not delete Comment from database' do
        expect do
          delete :destroy, id: comment.id, format: :json
        end.not_to change(answer.comments, :count)
      end

      it 'renders error status' do
        delete :destroy, id: comment.id, format: :json

        json = JSON.parse(response.body)
        expect(json['status']).to eq 'error'
      end
    end
  end
end
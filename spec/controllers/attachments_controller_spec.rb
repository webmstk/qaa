require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question) }
  let!(:question_attachment) { create(:attachment, attachable: question) }
  let(:answer) { create(:answer, question: question) }
  let!(:answer_attachment) { create(:attachment, attachable: answer) }

  describe 'DELETE :destroy' do
    sign_in_user

    context 'user tries to delete somebody\'s question attachment' do
      it 'should delete file from question' do
        expect { delete :destroy, id: question_attachment, format: :js }.not_to change(Attachment, :count)
      end

      it 'renders :destroy view' do
        delete :destroy, id: question_attachment, format: :js

        expect(response).to render_template(:destroy)
      end
    end

    context 'user deletes own question attachment' do
      before { question.update_attribute(:user, @user) }

      it 'should delete file from question' do
        expect { delete :destroy, id: question_attachment, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'renders :destroy view' do
        delete :destroy, id: question_attachment, format: :js

        expect(response).to render_template(:destroy)
      end
    end


    context 'user tries to delete somebody\'s answer attachment' do
      it 'should delete file from answer' do
        expect { delete :destroy, id: answer_attachment, format: :js }.not_to change(Attachment, :count)
      end

      it 'renders :destroy view' do
        delete :destroy, id: answer_attachment, format: :js

        expect(response).to render_template(:destroy)
      end
    end

    context 'user deletes own answer attachment' do
      before { answer.update_attribute(:user, @user) }

      it 'should delete file from question' do
        expect { delete :destroy, id: answer_attachment, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'renders :destroy view' do
        delete :destroy, id: answer_attachment, format: :js

        expect(response).to render_template(:destroy)
      end
    end

  end
end
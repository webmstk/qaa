require 'rails_helper'

describe 'Answers API' do
  let(:question) { create :question }
  let(:access_token) { create :access_token }

  describe 'GET /index' do
    let(:path) { "/api/v1/questions/#{question.id}/answers/" }
    let(:request_method) { :get }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get path, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answer' do
        expect(response.body).to have_json_size(2).at_path('answers/')
      end

      %w(id user_id body best created_at updated_at rating).each do |attr|
        it "contains #{attr}" do
          # другой порядок сортировки ответов, как поправить?
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/1/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create :answer, question: question }
    let(:path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:request_method) { :get }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:comment) { create :comment, commentable: answer }
      let!(:attachment) { create :attachment, attachable: answer }

      before do
        get path, format: :json, access_token: access_token.token
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at rating user_id).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}/")
        end
      end

      context 'comments' do
        it 'included in answer body' do
          expect(response.body).to have_json_size(1).at_path('answer/comments/')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                     .at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question body' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json)
                                                .at_path("answer/attachments/0/#{attr}")
          end
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    let(:request_method) { :post }

    context 'authorized' do
      let(:answer) { build :answer, question: question }

      it 'returns 200 status code' do
        post path, format: :json, access_token: access_token.token, answer: attributes_for(:answer)
        expect(response).to be_success
      end

      context 'with valid params' do
        it 'creates answer in database' do
          expect do
            post path, format: :json, access_token: access_token.token, answer: attributes_for(:answer)
          end.to change(Answer, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_question) { create :invalid_question }

        it 'does not create answer in database' do
          expect do
            post path, format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
          end.to_not change(Answer, :count)
        end

        it 'return error' do
          post path, format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end

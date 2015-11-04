require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create :access_token }

  describe 'GET /index' do
    let(:path) { '/api/v1/questions' }
    let(:request_method) { :get }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create :answer, question: question }

      before { get path, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question body' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create :question }
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: question }
    let!(:attachment) { create :attachment, attachable: question }
    let(:path) { "/api/v1/questions/#{question.id}" }
    let(:request_method) { :get }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { get path, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at rating user_id).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}/")
        end
      end

      context 'answers' do
        it 'included in question body' do
          expect(response.body).to have_json_size(1).at_path('question/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'included in question body' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question body' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json)
                                                .at_path("question/attachments/0/#{attr}")
          end
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do
    let(:path) { '/api/v1/questions' }
    let(:request_method) { :post }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:question) { build :question }

      it 'returns 200 status code' do
        post path, format: :json, access_token: access_token.token, question: attributes_for(:question)
        expect(response).to be_success
      end

      context 'with valid params' do
        it 'creates question in database' do
          expect do
            post path, format: :json, access_token: access_token.token, question: attributes_for(:question)
          end.to change(Question, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_question) { create :invalid_question }

        it 'does not create question in database' do
          expect do
            post path, format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          end.to_not change(Question, :count)
        end

        it 'return error' do
          post path, format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          expect(response.body).to have_json_path('errors')
        end
      end
    end
  end
end

require 'rails_helper'

describe 'Profile API' do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }

  describe 'GET /me' do
    let(:path) { '/api/v1/profiles/me' }
    let(:request_method) { :get }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { get path, format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    let(:path) { '/api/v1/profiles/' }
    let(:request_method) { :get }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:users) { create_list :user, 2 }
      let(:user) { users.first }

      before { get path, format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of users' do
        expect(response.body).to have_json_size(2).at_path('profiles/')
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("profiles/0/#{attr}")
        end
      end
    end
  end
end

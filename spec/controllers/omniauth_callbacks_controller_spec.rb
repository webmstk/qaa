require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create :user }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    # request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end


  describe 'GET #facebook' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'facebook',
                                                              uid: '123456',
                                                              info: { email: user.email } })
      get :facebook
    end

    it 'assigns user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to root_path 
    end
  end


  describe 'GET #vkontakte' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'vkontakte',
                                                              uid: '123456',
                                                              info: { email: user.email } })
      get :vkontakte
    end

    it 'assigns user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to root_path 
    end
  end


  describe 'GET #twitter' do
    before { request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'twitter',
                                                                     uid: '123456',
                                                                     info: { email: nil } }) }

    it 'assigns new user to @user' do
      get :twitter
      expect(assigns(:user)).to be_a_new User
    end

    it 'creates new Authorization' do
      expect { get :twitter }.to change(Authorization, :count).by(1)
    end

    it 'redirects to /users/email path' do
      get :twitter
      authorization = Authorization.last
      expect(response).to redirect_to "/users/email?authorization=#{authorization.id}"
    end
  end
end
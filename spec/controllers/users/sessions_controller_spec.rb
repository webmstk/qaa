require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:authorization) { create :authorization }
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #email' do
    context 'with authorization param' do
      it 'should load @authorization' do
        get :email, authorization: authorization
        expect(assigns(:authorization)).to eq authorization
      end

      it 'should render email view' do
        get :email, authorization: authorization
        expect(response).to render_template :email
      end
    end

    context 'without authorization param' do
      it 'should render thank_you view' do
        get :email
        expect(response).to render_template :thank_you
      end
    end
  end


  describe 'POST #email_sent' do
    context 'with valid parameters' do
      it 'it should redirect to email' do
        post :send_email, authorization: authorization.id, email: 'test@email.ru'
        expect(response).to redirect_to '/users/email'
      end
    end

    context 'with invalid parameters' do
      it 'should redirect to email view' do
        post :send_email, authorization: authorization.id, email: ''
        expect(response).to redirect_to "/users/email?authorization=#{authorization.id}"
      end
    end
  end


  describe 'GET #authorizate' do
    let(:code) { Digest::MD5.hexdigest(authorization.provider + authorization.uid + 'test@mail.ru') }

    context 'authorization already confirmed' do
      before { authorization.update(confirmed: true) }

      it 'should render confirmed view' do
        get :authorizate, authorization: authorization.id, email: 'test@mail.ru', code: code
        expect(response).to render_template :confirmed
      end
    end

    context 'authorizaton is not confirmed' do
      it 'should redirect to root_path' do
        get :authorizate, authorization: authorization.id, email: 'test@mail.ru', code: code
        expect(response).to redirect_to root_path
      end

      it 'should create new user' do
        expect { get :authorizate,
                 authorization: authorization.id,
                 email: 'test@mail.ru',
                 code: code }.to change(User, :count).by(1)
      end

      it 'should change authorization confirmed to true' do
        get :authorizate, authorization: authorization.id, email: 'test@mail.ru', code: code
        expect(authorization.reload.confirmed).to eq true
      end

      it 'should link authorization with user' do
        get :authorizate, authorization: authorization.id, email: 'test@mail.ru', code: code
        user = User.last

        expect(authorization.reload.user).to eq user
      end
    end
  end
end
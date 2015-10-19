require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :authorizations }

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456', confirmed: true)
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        context 'provider returns email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: '404@email.ru' }) }

          it 'creates new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_for_oauth(auth)).to be_a User
          end

          it 'fills user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info.email
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'creates confirmed authorization' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.confirmed).to eq true
          end
        end

        context 'provider does not return email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: nil }) }

          context 'authorization does not exitst' do
            it 'does not create new user' do
              expect { User.find_for_oauth(auth) }.to_not change(User, :count)
            end

            it 'returns a new user' do
              expect(User.find_for_oauth(auth)).to be_a_new User
            end

            it 'creates authorization' do
              expect { User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
            end

            it 'creates non-confirmed authorization' do
              User.find_for_oauth(auth)
              authorization = Authorization.find_by(uid: auth.uid)

              expect(authorization.confirmed).to eq false
            end
          end

          context 'authorization already exists' do
            let!(:authorization) { create(:authorization, provider: auth.provider, uid: auth.uid) }

            it 'does not create new authorization' do
              expect { User.find_for_oauth(auth) }.to_not change(Authorization, :count)
            end

            it 'updates existing authorization' do
              sleep 1

              updated_at = authorization.updated_at
              User.find_for_oauth(auth)

              expect(updated_at).to_not eq authorization.reload.updated_at
              # expect { User.find_for_oauth(auth) }.to change(authorization, :updated_at)
            end
          end
        end
      end
    end
  end


  describe '.authorize_user_by_auth_hash' do
    let(:authorization) { create(:authorization, confirmed: false)}

    context 'user exists' do
      let(:user) { create :user }
      before { authorization.update(user: user) }

      it 'should link authorization to user' do
        User.authorize_user_by_auth_hash(authorization, user.email)

        expect(authorization.reload.user).to eq user
      end

      it 'should confirm authorization' do
        User.authorize_user_by_auth_hash(authorization, user.email)

        expect(authorization.reload.confirmed).to eq true
      end
    end

    context 'user does not exist' do
      let(:user) { build :user }

      it 'should create new User' do
        expect { User.authorize_user_by_auth_hash(authorization, user.email) }.to change(User, :count).by(1)
      end

      it 'should link authorization to user' do
        User.authorize_user_by_auth_hash(authorization, user.email)

        expect(authorization.reload.user).to eq User.last
      end

      it 'should confirm authorization' do
        User.authorize_user_by_auth_hash(authorization, user.email)

        expect(authorization.reload.confirmed).to eq true
      end
    end
  end


  describe '#vote_for' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:another_question) { create(:question) }
    let(:another_vote) { create(:positive_vote, votable: question) }

    it 'should not return vote' do
      expect(user.vote_for(question)).to eq nil
      expect(user.vote_for(another_question)).to eq nil
    end

    it 'should return vote' do
      vote = create(:positive_vote, votable: question, user: user)
      expect(user.vote_for(question)).to eq vote
    end
  end

  describe '#voted_for?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:another_question) { create(:question) }
    let(:another_vote) { create(:positive_vote, votable: question) }

    it 'should not return vote' do
      expect(user.voted_for?(question)).to eq false
      expect(user.voted_for?(another_question)).to eq false
    end

    it 'should return vote' do
      vote = create(:positive_vote, votable: question, user: user)
      expect(user.voted_for?(question)).to eq true
    end
  end
end

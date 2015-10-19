class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :authorizations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :vkontakte, :twitter]


  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s, confirmed: true).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]

      if email
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      else
        user = User.new(password: password, password_confirmation: password)
        authorization = Authorization.find_or_initialize_by(provider: auth.provider, uid: auth.uid, confirmed: false)
        if authorization.persisted?
          authorization.touch
        else
          authorization.save
        end
      end
    end

    user
  end


  def vote_for(votable)
    @vote ||= Vote.find_by(votable: votable, user: self)
  end
  

  def voted_for?(votable)
    !!vote_for(votable)
  end


  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid, confirmed: true)
  end


  def self.get_auth_hash(authorization, email)
    return Digest::MD5.hexdigest(authorization.provider + authorization.uid + email)
  end


  def self.authorize_user_by_auth_hash(authorization, email)
    password = Devise.friendly_token[0, 20]
    user = User.where(email: email).first
    unless(user)
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    authorization.update(user: user, confirmed: true)

    return user
  end

end

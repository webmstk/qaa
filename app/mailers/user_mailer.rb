class UserMailer < ActionMailer::Base
  default from: 'info@qaa.dev'

  def verify_email(email, authorization)
    code = User.get_auth_hash(authorization, email)
    @link = users_authorizate_url(email: email, authorization: authorization, code: code)
    
    mail(to: email, subject: 'Подтвердите ваш email')
  end
end
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :load_user

  def facebook
    redirect_user('Facebook')
  end

  def vkontakte
    redirect_user('Вконтакте')
  end

  def twitter
    # render json: request.env['omniauth.auth']
    redirect_user('Твиттер')
  end

  private

    def load_user
      @user = User.find_for_oauth(request.env['omniauth.auth'])
    end

    def redirect_user(provider)
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      else
        authorization = Authorization.find_by(uid: request.env['omniauth.auth']['uid'])
        redirect_to users_email_path(authorization: authorization)
      end
    end
end
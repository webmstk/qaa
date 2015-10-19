class Users::SessionsController < Devise::SessionsController
  before_action :load_authorization

  def email
    render :thank_you if @authorization.nil?
  end


  def send_email
    if params[:email].blank?
      redirect_to "/users/email?authorization=#{@authorization.id}"
      flash[:notice] = 'Укажите правильный email'
    else
      UserMailer.verify_email(params[:email], @authorization).deliver_now
      redirect_to '/users/email'
    end
  end


  def authorizate
    if @authorization.confirmed
      render :confirmed
    elsif User.get_auth_hash(@authorization, params[:email]) == params[:code]
      user = User.authorize_user_by_auth_hash(@authorization, params[:email])

      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
        # translation missing: ru.devise.sessions.user.success
      end
    end
  end


  private

    def load_authorization
      @authorization = Authorization.where(id: params[:authorization]).first
    end

end
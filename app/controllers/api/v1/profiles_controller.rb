class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    # render nothing: true
    respond_with all_users_except_owner
  end

  protected

    def all_users_except_owner
      # p current_resource_owner
      @users = User.where.not(id: current_resource_owner)
    end
end

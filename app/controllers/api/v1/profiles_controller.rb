class Api::V1::ProfilesController < ApplicationController
  # skip_authorization_check
  before_action :doorkeeper_authorize!

  authorize_resource class: User

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    # render nothing: true
    respond_with all_users_except_owner
  end

  protected

    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def all_users_except_owner
      # p current_resource_owner
      @users = User.where.not(id: current_resource_owner)
    end

    def current_ability
      @current_ability ||= Ability.new(current_resource_owner)
    end
end

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable

  def like
    status = @votable.rating_up(current_user)

    @votable.reload

    respond_to do |format|
      format.json { render json: { status: status, id: params[:vote_id], rating: @votable.rating } }
    end
  end

  def dislike
    status = @votable.rating_down(current_user)

    @votable.reload

    respond_to do |format|
      format.json { render json: { status: status, id: params[:vote_id], rating: @votable.rating } }
    end
  end

  private

    def load_votable
      @votable = params[:votable_type].classify.constantize.find(params[:vote_id])
    end

end
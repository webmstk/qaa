class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable
  respond_to :json

  def like
    status = @votable.rating_up(current_user)

    @votable.reload

    respond_to do |format|
      format.json { render json: { status: status, id: @votable.id, rating: @votable.rating } }
    end
    # respond_with(@votable.reload)
  end

  def dislike
    status = @votable.rating_down(current_user)

    @votable.reload

    respond_to do |format|
      format.json { render json: { status: status, id: @votable.id, rating: @votable.rating } }
    end
  end

  private

    def load_votable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @votable = $1.classify.constantize.find(value)
        end
      end
      nil
    end

end
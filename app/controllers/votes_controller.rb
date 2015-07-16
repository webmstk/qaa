class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable

  def like
    if @votable.user_id != current_user.id
      vote = Vote.find_by(votable_id: params[:vote_id], votable_type: params[:votable_type], user_id: current_user)

      if !vote
        Vote.create(user_id: current_user.id, # без .id записывается <User:0x00000006890d40>
                    votable_type:  params[:votable_type],
                    votable_id:    params[:vote_id],
                    status: 1 )

        @votable.rating_up

        respond_to do |format|
          format.json { render json: { status: 'success', id: params[:vote_id] } }
        end
      elsif vote.status == -1
        vote.destroy
        @votable.rating_up

        respond_to do |format|
          format.json { render json: { status: 'vote_canceled', id: params[:vote_id] } }
        end
      else
        respond_to do |format|
          format.json { render json: { status: 'voted_before' } }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { status: 'forbidden' } }
      end
    end
  end


  def dislike
    if @votable.user_id != current_user.id
      vote = Vote.find_by(votable_id: params[:vote_id], votable_type: params[:votable_type], user_id: current_user)

      if !vote
        Vote.create(user_id: current_user.id,
                    votable_type:  params[:votable_type],
                    votable_id:    params[:vote_id],
                    status: -1 )

        @votable.rating_down

        respond_to do |format|
          format.json { render json: { status: 'success', id: params[:vote_id] } }
        end
      elsif vote.status == 1
        vote.destroy
        @votable.rating_down

        respond_to do |format|
          format.json { render json: { status: 'vote_canceled', id: params[:vote_id] } }
        end
      else
        respond_to do |format|
          format.json { render json: { status: 'voted_before' } }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { status: 'forbidden' } }
      end
    end
  end


  private

    def load_votable
      #@votable = params[:votable_type].name.constantize.find(params[:vote_id])
      @votable = params[:votable_type].classify.constantize.find(params[:vote_id])
    end

end
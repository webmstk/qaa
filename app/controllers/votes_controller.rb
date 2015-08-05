class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable
  before_action :check_author
  before_action :load_vote
  before_action :check_voted_before

  def like
    if !@vote
      Vote.create(user_id: current_user.id,
                  votable_type:  params[:votable_type],
                  votable_id:    params[:vote_id],
                  value: 1 )

      status = 'success'
    elsif @vote.value == -1
      @vote.destroy

      status = 'vote_canceled'
    end

    @votable.reload

    respond_to do |format|
      format.json { render json: { status: status, id: params[:vote_id], rating: @votable.rating } }
    end
  end


  def dislike
    if !@vote
      Vote.create(user_id: current_user.id,
                  votable_type:  params[:votable_type],
                  votable_id:    params[:vote_id],
                  value: -1 )

      status = 'success'
    elsif @vote.value == 1
      @vote.destroy

      status = 'vote_canceled'
    end

    @votable.reload

    respond_to do |format|
      format.json { render json: { status: status, id: params[:vote_id], rating: @votable.rating } }
    end
  end


  private

    def load_votable
      #@votable = params[:votable_type].name.constantize.find(params[:vote_id])
      @votable = params[:votable_type].classify.constantize.find(params[:vote_id])
    end

    def check_author
      if @votable.user_id == current_user.id
        respond_to do |format|
          format.json { render json: { status: 'forbidden' } }
        end
      end
    end

    def load_vote
      @vote = Vote.find_by(votable_id: params[:vote_id], votable_type: params[:votable_type], user_id: current_user)
    end

    def check_voted_before
      value = (params[:action] == 'like') ? 1 : -1

      if(current_user.voted_for?(@votable, value))
        respond_to do |format|
          format.json { render json: { status: 'voted_before' } }
        end
      end
    end

end
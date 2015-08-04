class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable
  before_action :check_author
  before_action :load_vote
  before_action :check_liked_before, only: :like
  before_action :check_disliked_before, only: :dislike

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

    # два последующих метода так похожи, так хочется объединить их в один, как бы это сделать?
    def check_liked_before
      if(@vote && @vote.value == 1)
        respond_to do |format|
          format.json { render json: { status: 'voted_before' } }
        end
      end
    end

    def check_disliked_before
      if(@vote && @vote.value == -1)
        respond_to do |format|
          format.json { render json: { status: 'voted_before' } }
        end
      end
    end

end
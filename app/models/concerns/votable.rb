module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def rating_up(user)
      change_rating(user, 1)
    end

    def rating_down(user)
      change_rating(user, -1)
    end


    private

      def change_rating(user, value)
        if self.user_id == user.id
          return 'forbidden'
        end

        vote = user.vote_for(self)

        if !vote
          Vote.create(user: user, votable: self, value: value )
          return 'success'
        end
        
        if(vote.value == -value)
          vote.destroy
          return 'vote_canceled'
        end
        
        return 'voted_before' if vote.value == value
      end
  end
end
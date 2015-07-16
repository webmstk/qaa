module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def rating_up
      self.rating += 1
      self.save
    end

    def rating_down
      self.rating -= 1
      self.save
    end
  end
end
class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, :votable_type, :votable_id, presence: true

  after_create :rating_up
  after_destroy :rating_down
  
  private

    def rating_up
      self.votable.rating += self.value
      self.votable.save
    end

    def rating_down
      self.votable.rating -= self.value
      self.votable.save
    end

end
class Vote < ActiveRecord::Base
  after_create :rating_up
  after_destroy :rating_down
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, :votable_type, :votable_id, presence: true

  private

    def rating_up
      self.votable.rating += self.value # undefined method `increment' for 0:Fixnum
      self.votable.save
    end

    def rating_down
      self.votable.rating -= self.value
      self.votable.save
    end

end
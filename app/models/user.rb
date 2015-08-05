class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  def voted_for?(votable, value = false)
    vote = Vote.find_by(votable_id: votable.id, votable_type: votable.model_name.to_s, user_id: self.id)
    
    if vote
      if value
        return vote.value == value ? true : false
      end

      return true
    else
      return false
    end
  end
end

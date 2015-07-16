class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def vote_for(votable)
    @vote ||= Vote.find_by(votable: votable, user: self)
  end
  
  def voted_for?(votable)
    !!vote_for(votable)
  end

end

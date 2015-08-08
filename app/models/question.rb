class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
	has_many :answers, dependent: :destroy

	validates :title, :body, :user_id, presence: true
	validates :title, length: { in: 5..140 }


  def best_answer
    Answer.where({ question_id: self.id, best: true }).take
  end

end

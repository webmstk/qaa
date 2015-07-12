class Question < ActiveRecord::Base
  belongs_to :user
	has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

	validates :title, :body, :user_id, presence: true
	validates :title, length: { in: 5..140 }

  accepts_nested_attributes_for :attachments

  def best_answer
    Answer.where({ question_id: self.id, best: true }).take
  end
end

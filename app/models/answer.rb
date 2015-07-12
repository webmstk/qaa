class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments


  def toggle_best
    #Answer.where({ question: self.question, best: true }).update_all(best: false)

    best_answer = self.question.best_answer
    if best_answer
      best_answer.update(best: false)
    end

    unless self.best?
      self.best = true
      self.save
    end
  end
end


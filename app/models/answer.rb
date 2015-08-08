class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable
  
  belongs_to :user
  belongs_to :question
  validates :body, :question_id, :user_id, presence: true

  scope :sorted, -> { order(best: :desc, created_at: :asc) }

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


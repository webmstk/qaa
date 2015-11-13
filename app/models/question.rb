class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
	has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

	validates :title, :body, :user_id, presence: true
	validates :title, length: { in: 5..140 }

  scope :yesterday, -> { where(created_at: Time.current.yesterday.all_day) }

  after_create :subscribe


  def best_answer
    Answer.where({ question_id: self.id, best: true }).take
  end

  def subscribe
    subscriptions.create(user: user)
  end

end

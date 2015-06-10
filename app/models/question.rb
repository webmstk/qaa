class Question < ActiveRecord::Base
  belongs_to :user
	has_many :answers, dependent: :destroy

	validates :title, :body, :user_id, presence: true
	validates :title, length: { in: 5..140 }
end

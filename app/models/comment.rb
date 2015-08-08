class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :body, :commentable, :user_id, presence: true

  scope :sorted, -> { order(created_at: :asc) }
end

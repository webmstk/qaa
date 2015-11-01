class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at, :short_title, :rating, :user_id

  has_many :answers
  has_many :comments
  has_many :attachments

  def short_title
    object.title.truncate(10)
  end
end

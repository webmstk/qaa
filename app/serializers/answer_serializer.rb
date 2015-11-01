class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :best, :created_at, :updated_at, :rating

  has_many :comments
  has_many :attachments
end

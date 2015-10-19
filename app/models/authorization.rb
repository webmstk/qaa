class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :uid, :provider, presence: true
  validates :confirmed, inclusion: { in: [true, false] }
end

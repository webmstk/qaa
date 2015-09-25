require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :commentable } # этого же достаточно?
  it { should validate_presence_of :user_id }

  it { should belong_to :commentable }
  it { should belong_to :user }
end

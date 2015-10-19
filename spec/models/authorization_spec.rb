require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_inclusion_of(:confirmed).in_array([true, false]) }
  it { should belong_to :user }
end

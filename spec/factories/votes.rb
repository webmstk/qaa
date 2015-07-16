FactoryGirl.define do

  factory :positive_vote, class: Vote do
    user
    votable {question}
    value 1
  end

  factory :negative_vote, class: Vote do
    user
    votable {question}
    value -1
  end

end
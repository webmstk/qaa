FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  sequence :body do |n|
    "Some text #{n}"
  end

  factory :answer do
    user
    question
    body
  end

  factory :invalid_answer, class: Answer do
    body nil
    user
    question
  end

  factory :best_answer, class: Answer do
    user
    question
    body
    best true
  end

end

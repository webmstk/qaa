FactoryGirl.define do
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

end

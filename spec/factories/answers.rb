FactoryGirl.define do
  factory :answer do
    question
    body "MyText"
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
  end

end

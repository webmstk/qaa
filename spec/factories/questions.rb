FactoryGirl.define do
  factory :question do
    user
    title 'question title'
    body 'question body'
  end

  factory :invalid_question, class: Question do
    user
    title nil
    body nil
  end
end

FactoryGirl.define do
  factory :question do
    user
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }

    trait :yesterday_created_at do
      created_at { 1.day.ago }
    end

    factory :yesterday_question, traits: [:yesterday_created_at]
  end

  factory :invalid_question, class: Question do
    user
    title nil
    body nil
  end
end

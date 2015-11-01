FactoryGirl.define do

  factory :comment do
    body "MyText"
    commentable nil
    user
  end

  factory :invalid_comment, class: Comment do
    body ''
    commentable nil
  end

end

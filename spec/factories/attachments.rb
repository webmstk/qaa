FactoryGirl.define do
  factory :attachment do
    file { File.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end

end

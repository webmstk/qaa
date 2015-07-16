require 'rails_helper'

RSpec.configure do |config|
  #Capybara.javascript_driver = :webkit
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 5

  config.include FeatureMacros, type: :feature

  config.use_transactional_fixtures = false

  # DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    dir = "#{Rails.root}/public/uploads/"
    if Dir.exist? dir
      FileUtils.remove_dir(dir)
    end
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

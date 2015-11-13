class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    yesterday_questions = Question.yesterday.to_a

    unless yesterday_questions.empty?
      User.find_each do |user|
        DailyMailer.digest(user, yesterday_questions).deliver_later
      end
    end
  end
end

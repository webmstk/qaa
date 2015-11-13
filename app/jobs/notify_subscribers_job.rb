class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    # p answer
    # p answer.question
    # p answer.question.subscriptions
    answer.question.subscriptions.find_each do |subscription|
      NotifyMailer.answer_added(subscription.user, subscription.question).deliver_later
    end
  end
end

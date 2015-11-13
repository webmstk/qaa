class NotifyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notify_mailer.answer_added.subject
  #
  def answer_added(user, question)
    @question = question

    mail to: user.email, subject: 'Добавлен новый ответ к вопросу'
  end
end

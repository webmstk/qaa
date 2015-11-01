# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create(email: 'webmstk@mail.ru', password: '123456789', password_confirmation: '123456789', admin: true)
user2 = User.create(email: 'etalord@yandex.ru', password: '123456789', password_confirmation: '123456789')

question1 = Question.create(title: 'Есть ли жизнь на марсе?', body: 'Никак не могу разглядеть в свой телескоп', user: user1)
question2 = Question.create(title: 'Сколько весит килограмм железа?', body: 'Помогите, завтра сдавать!!!', user: user1)
question3 = Question.create(title: 'Почему трава зеленая?', body: 'Ведь должна быть оранжевая', user: user2)

answer1_1 = Answer.create(body: 'Не отвечайте, я уже нашёл!', question: question1, user: user1)
answer1_2 = Answer.create(body: 'А, не, это просто пятнышко', question: question1, user: user1)
answer1_3 = Answer.create(body: 'Хахаха', question: question1, user: user2)

answer2_1 = Answer.create(body: 'Килограмм, плюс минус 50!', question: question2, user: user2, best: true)
answer2_2 = Answer.create(body: 'Спасибо, выручил!', question: question2, user: user1)
answer2_3 = Answer.create(body: 'Главное, чтобы ты хорошо учился', question: question2, user: user2)

answer3_1 = Answer.create(body: 'Потому что хлорофилл', question: question3, user: user1)
answer3_2 = Answer.create(body: 'ЗЫ. Он зеленый', question: question3, user: user1)
answer3_3 = Answer.create(body: 'Хорошо. А почему хлорофилл зеленый?', question: question3, user: user2)

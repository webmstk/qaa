require 'rails_helper'

feature 'create answer to question', %q{
	In order to answer to a question
	As an user
	I want to answer question
} do

	given(:user) { create(:user) }
	given(:question) { create(:question) }
	given(:answer) { build(:answer) }

	scenario 'authenticated user creates answer' do
		sign_in(user)

		visit question_path(question)
		fill_in 'Сообщение', with: answer.body
		click_on 'Ответить'

		expect(current_path).to eq question_path(question)
		expect(page).to have_content answer.body
	end

	scenario 'authenticated user creates invalid answer' do
		sign_in(user)

		visit question_path(question)
		fill_in 'Сообщение', with: ''
		click_on 'Ответить'

		expect(current_path).to eq question_answers_path(question)
		expect(page).to have_content 'Не удалось сохранить ответ'
		expect(page).not_to have_content answer.body
	end

	scenario 'non-authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Сообщение', with: answer.body
    click_on 'Ответить'
    
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Вам необходимо войти в систему
                                  или зарегистрироваться.'

    visit question_path(question)
    expect(page).not_to have_content answer.body
	end

end

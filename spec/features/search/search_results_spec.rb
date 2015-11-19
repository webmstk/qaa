# require 'support/sphinx'
#
# feature 'search results' do
#
#   let!(:question) { create :question, title: 'lalala' }
#   # before { ThinkingSphinx::Test.index }
#
#   scenario 'asdf' do
#     visit search_path
#     fill_in 'search_input', with: 'lalala'
#     click_on 'Поиск'
#
#     within '#search_result' do
#       expect(page).to have_content('lalala')
#     end
#   end
# end

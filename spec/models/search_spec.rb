require 'rails_helper'

RSpec.describe Search, type: :model do
  # describe '.models_list' do
  #   it 'includes Question model' do
  #     expect(Search.models_list).to include('Question' => 'Вопросы')
  #   end
  #
  #   it 'includes Answer model' do
  #     expect(Search.models_list).to include('Answer' => 'Ответы')
  #   end
  #
  #   it 'includes Comment model' do
  #     expect(Search.models_list).to include('Comment' => 'Комментарии')
  #   end
  #
  #   it 'includes User model' do
  #     expect(Search.models_list).to include('User' => 'Пользователи')
  #   end
  # end

  describe '.define_model' do
    context 'pass nothing as a model param' do
      it 'returns ThinkingSphinx model' do
        model = Search.define_model('', Search.models_list)
        expect(model).to be ThinkingSphinx
      end
    end

    context 'pass non-existing value as a model param' do
      it 'returns ThinkingSphinx model' do
        model = Search.define_model('asdf', Search.models_list)
        expect(model).to be ThinkingSphinx
      end
    end

    context 'pass a model in params' do
      it 'returns specified model' do
        model = Search.define_model('Answer', Search.models_list)
        expect(model).to be Answer
      end
    end
  end
end
require 'rails_helper'

RSpec.describe SearchController do
  describe 'GET #index' do
    it 'invokes :search method of ThinkingSphinx' do
      expect(ThinkingSphinx).to receive(:search)
      get :index, q: 'word'
    end

    it 'invokes :search_for method of Search' do
      expect(Search).to receive(:search_for)
      get :index, q: 'word'
    end
  end
end
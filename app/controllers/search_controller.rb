class SearchController < ApplicationController
  skip_authorization_check

  def index
    @models = Search::Models
    @result = Search.search_for(params)
  end
end
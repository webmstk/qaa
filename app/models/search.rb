class Search

  Models = {
      'Question' => 'Вопросы',
      'Answer'   => 'Ответы',
      'Comment'  => 'Комментарии',
      'User'     => 'Пользователи',
  }

  def self.search_for(params)
    model = define_model(params[:m], Models)
    model.search Riddle::Query.escape(params[:q])
  end

  def self.define_model(model, models_list)
    models_list.has_key?(model) ? model.constantize : ThinkingSphinx
  end

end
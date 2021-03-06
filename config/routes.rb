require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  use_doorkeeper
  concern :commentable do
      resources :comments, shallow: true, only: [:create, :destroy]
  end

  concern :votable do
    resources :votes, only: [] do
      post :like, on: :collection
      post :dislike, on: :collection
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', sessions: 'users/sessions' }

  devise_scope :user do
    get '/users/email' => 'users/sessions#email'
    post '/users/email' => 'users/sessions#send_email'
    get '/users/authorizate' => 'users/sessions#authorizate'
  end

  resources :questions, concerns: [:commentable, :votable] do
    resources :answers, only: [:destroy, :update, :create], shallow: true, concerns: [:commentable, :votable] do
      get :best
    end
    post :subscribe
    post :unsubscribe
  end

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end

  get 'search' => 'search#index'

  root 'questions#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

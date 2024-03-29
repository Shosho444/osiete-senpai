Rails.application.routes.draw do
  get 'answers/create'
  root "questions#index"
  resources :users, only: %i[new create show edit update]
  resources :questions do
    get 'mine', on: :member
    resources :answers, only: %i[create]
  end
  resources :industries, only: %i[index]
  resources :likes, only: %i[create destroy]

  get 'tops/index', to: 'tops#index'
  get 'login', to: 'user_sessions#new'
  get 'recommendation', to: 'user_sessions#modal'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
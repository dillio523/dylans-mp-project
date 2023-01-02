Rails.application.routes.draw do
  get 'constituencies/index'
  get 'pages/home'
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/create'
  get 'users/edit'
  get 'users/update'
  get 'users/destroy'
  mount Sidekiq::Web => "/sidekiq" if defined?(Sidekiq) # monitoring console
  root to: 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
  get '/success', to: 'users#success'
  resources :members
  resources :constituencies
  resources :postcodes
  get '/search', to: 'postcodes#search'






  # Defines the root path route ("/")
  # root "articles#index"
end

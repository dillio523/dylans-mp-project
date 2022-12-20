Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/create'
  get 'users/edit'
  get 'users/update'
  get 'users/destroy'
  mount Sidekiq::Web => "/sidekiq" if defined?(Sidekiq) # monitoring console
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
  get '/success', to: 'users#success'
  resources :members


  # Defines the root path route ("/")
  # root "articles#index"
end

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" if defined?(Sidekiq) # monitoring console
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

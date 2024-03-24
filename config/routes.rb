Rails.application.routes.draw do
  resources :messages
  resources :offers
  resources :categories
  resources :listings
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "landing_page#index"
end

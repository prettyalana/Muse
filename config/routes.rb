Rails.application.routes.draw do
  root "landing_page#show"

  # Remove the unncessary spacing/blank lines in 4-7



  devise_for :users, controllers: { registrations: 'user/registrations' }

  resources :messages
  resources :offers
  resources :categories
  resources :listings

  get "/home" => "home#show"
  get "/:username" => "users#show", as: :user
end

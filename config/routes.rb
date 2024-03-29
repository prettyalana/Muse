Rails.application.routes.draw do
  root "listings#index"




  devise_for :users

  resources :messages
  resources :offers
  resources :categories
  resources :listings

  get "/:username" => "users#show", as: :user
end

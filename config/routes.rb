Rails.application.routes.draw do
  root "listings#index"




  devise_for :users, controllers: { registrations: 'user/registrations' }

  resources :messages
  resources :offers
  resources :categories
  resources :listings

  get "/:username" => "users#show", as: :user
end

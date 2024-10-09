Rails.application.routes.draw do
  root "landing_page#show"




  devise_for :users, controllers: { registrations: 'user/registrations' }

  resources :offers
  resources :categories
  resources :listings do
    resources :messages, only: [:new, :create]
  end
  resources :messages

  get "/home" => "home#show"
  get "/:username" => "users#show", as: :user
end

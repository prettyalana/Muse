Rails.application.routes.draw do
  root "landing_page#show"

  devise_for :users, controllers: { registrations: "user/registrations" }

  resources :offers

  if Rails.env.development?
    resources :categories
  end

  resources :listings do
    get 'messages/thread', to: 'messages#message_thread', as: 'messages_thread'
    resources :messages, only: [:new, :create]
  end

  resources :messages

  get "/home" => "home#show"
  get "/:username" => "users#show", as: :user
end

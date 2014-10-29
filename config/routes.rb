Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

  namespace :admin do
    root to: 'home#index'

    resources :users
    
    resources :signed_urls, only: :index
  end
end

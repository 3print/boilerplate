Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', masquerades: 'admin/masquerades' }

  get '/result', to: 'static#s3_results', as: :s3_results

  resources :bp_tests # BOILERPLATE_ONLY
  namespace :admin do
    root to: 'home#index'

    resources :users
    resources :bp_tests  do   # BOILERPLATE_ONLY
      member do               # BOILERPLATE_ONLY
        put :approve          # BOILERPLATE_ONLY
        put :revocate         # BOILERPLATE_ONLY
        put :validate         # BOILERPLATE_ONLY
        put :unvalidate       # BOILERPLATE_ONLY
      end                     # BOILERPLATE_ONLY
    end                       # BOILERPLATE_ONLY

    resources :signed_urls, only: :index
  end
end

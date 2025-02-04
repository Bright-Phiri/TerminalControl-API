Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :subscriptions, only: :create
      resources :taxpayers, except: [ :create, :update ] do
        member do
          get "show_payments"
          get "show_terminals"
        end
        resources :payments
      end
      resources :terminals, only: :index
      resources :users do
        post "register", on: :collection
      end
      resources :authentication, only: [] do
        post "login", on: :collection
      end
    end
  end
end

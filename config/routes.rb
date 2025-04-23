# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  mount ActionCable.server => '/websocket'

  namespace :api do
    namespace :v1 do
      resources :subscriptions, except: :create do
        post "renew", on: :member
        get "show_payments", on: :member
      end
      resources :taxpayers, except: [ :create, :update ] do
        member do
          get "show_payments"
          get "show_terminals"
          get "show_subscription"
        end
        collection do
          post "subscribe_taxpayer"
          post "login"
        end
        resources :subscriptions, only: :create
      end
      resources :terminals, only: [ :index, :show ] do
        post "check_terminal_status", on: :collection
      end
      resources :payments, only: [ :index, :show ]
      resources :users do
        post "register", on: :collection
        member do
          patch "disable"
          patch "activate"
        end
      end
      resources :authentication, only: [] do
        post "login", on: :collection
      end
    end
  end
end

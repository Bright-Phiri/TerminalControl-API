# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  mount ActionCable.server => "/websocket"
  mount MissionControl::Jobs::Engine, at: "/jobs"

  namespace :api do
    namespace :v1 do
      resources :subscriptions, except: :create do
        member do
          post :renew
          get :show_payments
        end
      end
      resources :taxpayers, except: [ :create, :update ] do
        member do
          get "show_payments"
          get "show_terminals"
          post "block_terminals"
          post "unblock_terminals"
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
      resources :activity_logs, only: :index
      resources :passwords, except: [ :index, :create, :show, :update, :destroy ] do
        patch "update_password", on: :member
        collection do
          post "forgot_password"
          post "reset_password"
          post "verify_password_reset_token"
        end
      end
    end
  end
end

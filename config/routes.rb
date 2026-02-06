# typed: false
# frozen_string_literal: true

Rails.application.routes.draw do
  root "dashboard#index"

  resources :accounts do
    collection do
      get :bulk_update
      post :save_bulk_update
    end
    resources :snapshots, only: [:create]
  end

  get "settings", to: "settings#index"

  # JSON endpoints for charts
  namespace :api do
    get "net_worth_history", to: "charts#net_worth_history"
    get "sankey_data", to: "charts#sankey_data"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end

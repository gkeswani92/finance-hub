# typed: false
# frozen_string_literal: true

Rails.application.routes.draw do
  root "dashboard#index"

  resources :accounts do
    collection do
      get :bulk_update
      post :save_bulk_update
    end
    member do
      patch :unarchive
    end
    resources :snapshots, only: [:create]
  end

  get "settings", to: "settings#index"
  post "settings/owners", to: "settings#create_owner", as: :settings_owners
  delete "settings/owners/:id", to: "settings#destroy_owner", as: :settings_owner
  post "settings/categories", to: "settings#create_category", as: :settings_categories
  patch "settings/categories/:id", to: "settings#update_category", as: :settings_category
  delete "settings/categories/:id", to: "settings#destroy_category"

  # JSON endpoints for charts
  namespace :api do
    get "net_worth_history", to: "charts#net_worth_history"
    get "sankey_data", to: "charts#sankey_data"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end

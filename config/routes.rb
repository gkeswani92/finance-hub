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
    resources :snapshots, only: [:create, :destroy]
  end

  get "settings", to: "settings#index"
  post "settings/members", to: "settings#create_member", as: :settings_members
  patch "settings/members/:id", to: "settings#update_member", as: :settings_member
  delete "settings/members/:id", to: "settings#destroy_member"
  post "settings/members/reorder", to: "settings#reorder_members"
  post "settings/categories", to: "settings#create_category", as: :settings_categories
  patch "settings/categories/:id", to: "settings#update_category", as: :settings_category
  delete "settings/categories/:id", to: "settings#destroy_category"
  post "settings/categories/reorder", to: "settings#reorder_categories"
  patch "settings/display_currency", to: "settings#update_display_currency", as: :settings_update_display_currency

  get "performance", to: "performance#index"

  get "import", to: "imports#index"
  post "import/parse", to: "imports#parse"
  post "import/execute", to: "imports#execute"

  # JSON endpoints for charts
  namespace :api do
    get "net_worth_history", to: "charts#net_worth_history"
    get "sankey_data", to: "charts#sankey_data"
    get "allocation_by_asset_type", to: "charts#allocation_by_asset_type"
    get "allocation_by_member", to: "charts#allocation_by_member"
    get "allocation_by_currency", to: "charts#allocation_by_currency"
    get "notifications", to: "notifications#index"
    patch "notifications/:id/read", to: "notifications#mark_read"
    patch "notifications/mark_all_read", to: "notifications#mark_all_read"
  end

  get "onboarding", to: "onboarding#index"
  post "onboarding/create_family", to: "onboarding#create_family"
  post "onboarding/join_family", to: "onboarding#join_family"

  namespace :admin do
    root to: "dashboard#index"
    resources :users, only: [:index]
    resources :families, only: [:index, :show]
    resources :exchange_rates, only: [:index, :create]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end

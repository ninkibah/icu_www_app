IcuWwwApp::Application.routes.draw do
  root to: "pages#home"

  get  "sign_in"  => "sessions#new"
  get  "sign_out" => "sessions#destroy"
  get  "redirect" => "redirects#redirect"

  %w[home system_info].each do |page|
    get page => "pages##{page}"
  end
  %w[shop cart card charge confirm completed].each do |page|
    match page => "payments##{page}", via: page == "charge" ? :post : :get
  end
  %w[account preferences update_preferences].each do |page|
    match "#{page}/:id" => "users##{page}", via: page.match(/^update/) ? :post : :get, as: page
  end

  resources :cart_items,        only: [:destroy]
  resources :clubs,             only: [:index, :show]
  resources :entries,           only: [:new, :create]
  resources :player_ids,        only: [:index]
  resources :players,           only: [:index]
  resources :sessions,          only: [:create]
  resources :subscriptions,     only: [:new, :create]

  namespace :admin do
    resources :bad_logins,        only: [:index]
    resources :carts,             only: [:index, :show]
    resources :clubs,             only: [:new, :create, :edit, :update]
    resources :entry_fees do
      get :rollover, :clone, on: :member
    end
    resources :journal_entries,   only: [:index, :show]
    resources :logins,            only: [:index, :show]
    resources :players,           only: [:show, :new, :create, :edit, :update]
    resources :subscriptions,     only: [:index]
    resources :subscription_fees do
      get :rollover, on: :member
    end
    resources :translations,      only: [:index, :show, :edit, :update, :destroy]
    resources :users do
      get :login, on: :member
    end
  end

  match "*url", to: "pages#not_found", via: :all
end

Rails.application.routes.draw do
  devise_for :users

  root "dashboards#index"

  get "admin/dashboard", to: "dashboards#admin"
  get "manager/dashboard", to: "dashboards#manager"
  get "viewer/dashboard", to: "dashboards#viewer"

  resources :users, only: [:index, :new, :create]

  resources :warehouses do
    resources :locations
    resources :stock_items do
      member do
        put :put_away
        post :reduce
      end
    end
  end
end
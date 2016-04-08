Rails.application.routes.draw do
  resource :profile, only: [:show, :edit, :update]

  resources :donations, only: [] do
    resource :confirmation, only: [:create, :destroy, :update]
  end
  resources :pre_registrations, only: [:create]
  resources :registrations, only: [:create, :new]
  resources :subscriptions, only: [:create, :new]

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/pages/*id" => 'pages#show', as: :page, format: false

  constraints Clearance::Constraints::SignedIn.new(&:admin?) do
    resources :zones, only: [:create, :index, :new, :show] do
      resources :scheduled_pickups, only: [:edit, :show, :new, :create, :update]
    end

    get "/" => redirect("/zones")
  end

  constraints Clearance::Constraints::SignedIn.new do
    get "/" => redirect("/profile")
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "marketing#index"
  end
end

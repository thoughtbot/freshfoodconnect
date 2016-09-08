Rails.application.routes.draw do
  resource :profile, only: [:show, :edit, :update]

  resources :donations, only: [:edit, :update] do
    resource :confirmation, only: [:create, :destroy, :update]
  end
  resource :location, only: [:update]
  resources :pre_registrations, only: [:create]

  resources :zones, only: [] do
    resources :registrations, only: [:create, :new]
    resources :subscriptions, only: [:create, :new]
  end

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

  constraints Clearance::Constraints::SignedIn.new(&:regional_admin?) do
    resources :cyclist_invitations, only: [:new, :create, :show]
    resources :donors, only: [:show]
    resources :users, only: [:index, :destroy] do
      resource :promotion, only: [:create, :destroy]
    end
    resources :zones, only: [:create, :index, :new, :show, :edit, :update] do
      resources(
        :scheduled_pickups,
        path: :donations,
        only: [:edit, :show, :new, :create, :update],
      )
    end
    resources :regions, only: [:create, :destroy, :index, :new, :show] do
      resources(
        :zones,
        only: [:create, :destroy, :new],
        controller: :region_zones
      )
    end

    resources :region_admins, only: [:new, :create, :destroy]


    get "/" => redirect("/zones")
  end

  constraints Clearance::Constraints::SignedIn.new(&:staff?) do
    resources :donations, only: [:show] do
      resource :pickup, only: [:update, :destroy]
    end
    resources :subscriptions, only: [:index]

    resources :zones, only: [] do
      resources(
        :scheduled_pickups,
        path: :donations,
        only: [],
      ) do
        resource :checklist, only: [:show], controller: :pickup_checklists
      end
    end
  end

  constraints Clearance::Constraints::SignedIn.new(&:cyclist?) do
    get "/" => "latest_pickup_checklists#show"
  end

  constraints Clearance::Constraints::SignedIn.new do
    get "/" => redirect("/profile")
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "marketing#index"
  end
end

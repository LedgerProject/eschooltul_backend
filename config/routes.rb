Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "schools#show"
      get "/settings", to: "schools#edit"

      resource :school, only: %i[update]
      resources :courses do
        post :duplicate, on: :member
      end
    end

    unauthenticated do
      root to: "devise/sessions#new", as: "root_unauthenticated"
    end
  end
end

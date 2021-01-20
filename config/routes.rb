Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "schools#show"
      get "/settings", to: "schools#edit"

      resource :school, only: %i[update]
      resources :accounts, except: %i[show]
      resources :courses, except: %i[show] do
        post :duplicate, on: :member
      end
      resources :students, except: %i[show] do
        post :deactivate, on: :member
        collection do
          resources :import_ed_record, only: %i[new create]
        end      
      end
    end

    unauthenticated do
      root to: "devise/sessions#new", as: "root_unauthenticated"
    end
  end
end

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

      resources :grades, only: %i[index create]

      namespace :grades do
        resources :courses, only: %i[index] do 
          resources :terms, except: %i[show]
          resources :lessons, except: %i[show] do 
            collection do
              resources :lesson_types, except: %i[show]
            end
          end 
        end
      end
    end

    unauthenticated do
      root to: "devise/sessions#new", as: "root_unauthenticated"
    end
  end
end

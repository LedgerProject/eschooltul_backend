Rails.application.routes.draw do
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  scope "(:locale)", locale: /en|es/ do
    resources :validators, only: %i[new show create], param: :content_hash
    devise_for :users

    devise_scope :user do
      authenticated :user do
        root to: "schools#show"
        get "/settings", to: "schools#edit"

        resources :attachment, only: :destroy
        resource :school, only: %i[update]
        resources :accounts, except: %i[show]
        resources :courses, except: %i[show] do
          post :duplicate, on: :member
          post :discard, on: :member
          post :undiscard, on: :member
        end
        resources :students, except: %i[show] do
          post :deactivate, on: :member
          collection do
            resources :import_ed_record, only: %i[new create]
          end
          resources :student_edas, only: %i[new create]
        end
      end
      resources :students, except: %i[show] do
        post :deactivate, on: :member
        collection do
          resources :import_ed_record, only: %i[new create]
        end
      end

      resources :discard_courses, only: %i[index]

      resources :report, only: %i[show]

      resources :grades, only: %i[create]

      namespace :grades do
        resources :courses, only: %i[index show] do
          resources :terms, except: %i[show]
          resources :lessons, except: %i[show] do
            collection do
              resources :lesson_types, except: %i[show]
            end
          end
        end
      end
      unauthenticated do
        root to: "devise/sessions#new", as: "root_unauthenticated"
      end
    end
  end
end

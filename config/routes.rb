Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "schools#show"

      resource :school, except: %i[new create destroy]
    end

    unauthenticated do
      root to: "devise/sessions#new", as: "root_unauthenticated"
    end
  end
end

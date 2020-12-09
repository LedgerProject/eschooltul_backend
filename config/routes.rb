Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "home#index"
    end

    unauthenticated do
      root to: "devise/sessions#new", as: "root_unauthenticated"
    end
  end
end

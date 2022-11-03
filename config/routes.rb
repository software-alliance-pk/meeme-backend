Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#dashboard"
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          put :update_user
          post :forgot_password
          post :reset_user_password
        end
        get '/*a', to: 'application#not_found'
      end
      post '/auth/login', to: "authentication#login"
      post '/auth/logout', to: "authentication#logout"
    end
  end

  # post '/auth/forgot_password', to: "authentication#forgot_password"

end

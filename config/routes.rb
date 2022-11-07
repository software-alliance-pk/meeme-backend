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
          get :all_data

        end
        get '/*a', to: 'application#not_found'
      end
      post '/auth/login', to: "authentication#login"
      post '/auth/logout', to: "authentication#logout"
      post '/social/social_login', to: "social_login#social_login"
      resources :posts do
        collection do
          put :update_posts
        end
      end
      resources :comments do
        collection do
          put :update_comments
          get :child_comments
          put :update_child_comments
          delete :child_comment_destroy
        end
      end
    end
  end

  # post '/auth/forgot_password', to: "authentication#forgot_password"

end

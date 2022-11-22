Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#dashboard"
  get '/dashboard', to: "dashboard#dashboard"
  get '/welcome', to: "dashboard#welcome"
  get '/signin', to: "dashboard#signin"
  get '/signup', to: "dashboard#signup"
  get '/forgot-password', to: "dashboard#forgot_password"
  get '/reset-password', to: "dashboard#reset_password"
  get '/verification', to: "dashboard#verification"
  get '/notifications', to: "dashboard#notifications"
  get '/admin-profile', to: "dashboard#admin_profile"
  get '/tournament', to: "dashboard#tournament"
  get '/tournament-banner', to: "dashboard#tournament_banner"
  get '/winner-detail', to: "dashboard#winner_detail"
  get '/user-list', to: "dashboard#user_list"
  get '/gift-rewards', to: "dashboard#gift_rewards"
  get '/transactions', to: "dashboard#transactions"
  get '/faqs', to: "dashboard#faqs"
  get '/faqs-edit', to: "dashboard#faqs_edit"
  get '/popup', to: "dashboard#popup"
  get '/popup-edit', to: "dashboard#popup_edit"
  get '/privacy', to: "dashboard#privacy"
  get '/privacy-edit', to: "dashboard#privacy_edit"
  get '/terms', to: "dashboard#terms"
  get '/terms-edit', to: "dashboard#terms_edit"
  get '/support', to: "dashboard#support"
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          put :update_user
          post :forgot_password
          post :reset_user_password
          get :all_posts
          get :open_profile

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
          post :create_child_comment
        end
      end
      resources :likes do

      end
    end
  end

  # post '/auth/forgot_password', to: "authentication#forgot_password"

end

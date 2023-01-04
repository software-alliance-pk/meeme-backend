Rails.application.routes.draw do
  devise_for :admin_users
  mount ActionCable.server => "/cable"
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes p  er the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root to: 'home#index'
  root "dashboard#homepage"
  get '/dashboard', to: "dashboard#dashboard"
  get '/welcome', to: "dashboard#welcome"
  get '/signin', to: "dashboard#signin"
  get '/signup', to: "dashboard#signup"
  get '/forgot-password', to: "dashboard#forgot_password"
  get '/reset-password', to: "dashboard#reset_password"
  get '/follower_count', to: "dashboard#follower_count"
  get '/verification', to: "dashboard#verification"
  get '/notifications', to: "dashboard#notifications"
  post '/notifications', to: "notification#create_notification"
  get '/admin-profile', to: "dashboard#admin_profile"
  patch '/admin-profile', to: "dashboard#admin_profile"
  post '/admin-profile', to: "dashboard#admin_profile"
  get '/tournament', to: "dashboard#tournament"
  get '/tournament-users', to: "dashboard#tournament_users"
  get '/tournament-banner', to: "dashboard#tournament_banner"
  post '/tournament-banner' , to: "dashboard#tournament_banner_create"
  delete 'tournament-banner/:id', to: 'dashboard#tournament_banner_destroy'
  get 'tournament-banner/:id', to: 'dashboard#tournament_banner_destroy'
  get '/winner-detail', to: "dashboard#winner_detail"
  get '/user-list', to: "dashboard#user_list"
  get '/user-export', to: 'dashboard#user_export'
  get '/transaction-export', to: 'dashboard#transaction_export'
  get '/show_user_profile', to: "dashboard#show_user_profile"
  get '/specific_user_transactions', to: "dashboard#specific_user_transactions"
  get '/inventory', to: "dashboard#gift_rewards", as: "card_inventory"
  post '/inventory', to: "amazon_card#create_amazon_card"
  delete '/gift-rewards/:id', to: 'amazon_card#card_destroy'
  get '/gift-rewards/:id/gift_rewards_update', to: 'dashboard#update_card', as: 'update_card'
  patch '/gift-rewards', to: "amazon_card#update_card"
  get '/gift-rewards/:id', to: 'amazon_card#card_destroy'
  post '/gift-rewards', to: "amazon_card#add_gift_card"
  get '/gift-rewards', to: "dashboard#gift_rewards"
  get '/transactions', to: "dashboard#transactions"
  get '/faqs', to: "dashboard#faqs"
  get '/faqs-edit', to: "dashboard#faqs_edit"
  post '/faqs-edit', to: "dashboard#faq_create"
  delete 'faqs/:id', to: 'dashboard#faq_destroy'
  get 'faqs/:id', to: 'dashboard#faq_destroy'
  get 'faqs/:id/faq-update', to: 'dashboard#faq_update', as: 'faq_update'
  patch '/faqs', to: "dashboard#faq_update"
  get '/pop-ups', to: "dashboard#popup"
  get '/pop-ups-edit', to: "dashboard#popup_edit"
  post '/pop-ups-edit', to: "dashboard#popup_create"
  delete 'pop-ups/:id', to: 'dashboard#popup_destroy'
  get 'pop-ups/:id', to: 'dashboard#popup_destroy'
  get 'pop-ups/:id/popup-update', to: 'dashboard#popup_update', as: 'popup_update'
  patch '/pop-ups', to: "dashboard#popup_update"
  get '/privacy', to: "dashboard#privacy"
  post '/privacy', to: "dashboard#privacy_edit"
  get '/privacy-edit', to: "dashboard#privacy_edit"
  get '/terms', to: "dashboard#terms"
  post '/terms', to: "dashboard#terms_edit"
  get '/terms-edit', to: "dashboard#terms_edit"
  get '/support', to: "dashboard#support"
  post '/support', to: "support#create_message"
  get '/conversation', to: "support#show_chat"
  get '/conversations', to: "dashboard#support"
  get '/conversation-image', to: "support#get_profile_image"
  get '/completed', to: "support#issue_resolved"
  get '/admin-user-image', to: "support#admin_user_images"
  get '/tournament-winner-list', to: "dashboard#tournament_winner_list"
  get '/winner-reward', to: "dashboard#winner_reward"
  get '/post-images', to: "dashboard#post_images"

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          put :update_user
          post :forgot_password
          post :reset_user_password
          post :verify_otp
          get :all_posts
          get :open_profile
          get :open_current_user
          get :open_some_other_user
          post :email_validate
          post 'payments/add_user_to_stripe',to: "payments#add_user_to_stripe"
          post 'payments/add_a_card',to: "payments#add_a_card"
          get 'payments/fetch_all_card',to: "payments#fetch_all_card"
          delete 'payments/delete_a_card',to: "payments#delete_a_card"
          post 'payments/charge_a_customer',to: "payments#charge_a_customer"
          get 'payments/show_transactions_history',to: "payments#show_transactions_history"

        end
        get '/*a', to: 'application#not_found'
      end
      post '/auth/login', to: "authentication#login"
      post '/auth/logout', to: "authentication#logout"
      post '/social/social_login', to: "social_login#social_login"
      resources :posts do
        collection do
          put :update_posts
          post :explore
          get :following_posts
          get :recent_posts
          get :trending_posts
          get :tags
          post :other_posts
          post :user_search_tag
          post :share_post

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
      resources :followers do
        collection do
          put :update_follower
          get :show_pending_requests
          post :send_a_follow_request_to_user
          get :show_people
          post :un_follow_user

        end
      end
      resources :tournament_banners do
        collection do
          post :enroll_in_tournament
          get :tournament_posts
          post :like_unlike_a_tournament_post
          post :dislike_a_tournament_post
          post :create_tournament
          get :show_tournament_rules
          get :show_tournament_prices
          get :tournament_winner
          get :judge
          get :top_10_positions
        end
      end
      resources :stories do
        collection do
          post :like_dislike_a_story
          post :story_comment
          get :show_story_comments
        end
      end
      resources :stores do
        collection do
        end
      end
      resources :conversations do
        collection do
          post :create_support_conversation
        end
      end
      resources :messages do
        collection do
          get :individual_messages
          post :individual_admin_messages
          post :support_ticket
          post :support_chat
          get :fetch_all_users
          get :all_support_chats
        end
      end
      resources :badges do
        collection do
          get :current_user_badges
          get :rarity_1_badges
          get :rarity_2_badges
          get :rarity_3_badges
          get :current_user_locked_badges
          get :badge_rarity_search
        end
      end
    end

  end
end

require 'csv'

class DashboardController < ApplicationController

  include Rails.application.routes.url_helpers
  # include DailyCoinHelper
  def dashboard
    @user = User.order("id DESC").limit(4)
  end
 
  def welcome
  end

  def homepage
    if AdminUser.all == []
      redirect_to welcome_path
    elsif admin_user_signed_in?
      redirect_to dashboard_path
    else
      redirect_to new_admin_user_session_path
    end
  end

  def signin
  end

  def signout
  end

  def new
  end

  def signup
    if params[:password].length < 6
      flash[:length] = "Password is too short (minimum is 6 characters)"
    elsif params[:password] != params[:password_confirmation]
      flash[:confirmation] = "Password confirmation doesn't match Password"
    elsif params[:password] == params[:password_confirmation] && params[:email].match(/\A[^@\s]+@[^@\s]+\z/)
      @admin_user = AdminUser.create(email: params[:email], full_name: params[:full_name], admin_user_name: params[:admin_user_name], password: params[:password])
      if @admin_user.save
        redirect_to dashboard_path
      else
        flash[:mail] = "Email has already been taken"
      end
    else
      flash[:mail] = "Email is invalid"
    end
  end

  def sub_admin_sign_up
    render "dashboard/signup"
  end

  def forgot_password
  end

  def reset_password
  end

  def verification
  end

  def notifications
    if params[:id].present?
      @notify = Notification.find(params[:id])
      @notify.update(status: 1)
    end
  end

  def admin_profile
    if params[:email].present?
      @admin = AdminUser.find_by(email: params[:email])
    end
    if @admin.present?
      if params[:password] == "" && params[:admin_profile_image] == nil && params[:full_name].present? && params[:admin_user_name]
        if AdminUser.first.present?
            current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name])
            @updated = true
        end
      elsif params[:old_password].present? && current_admin_user.valid_password?(params[:old_password]) == false
        flash[:old_password] = "Old Password is wrong"
        @updated = false
      elsif params[:password] != nil && params[:password] != params[:password_confirmation]
        flash[:password_confirmation] = "Password confirmation doesn't match Password"
        @updated = false
        redirect_to admin_profile_path
      elsif params[:password] != nil && params[:password] == params[:password_confirmation] && current_admin_user.valid_password?(params[:old_password])
        current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name], password: params[:password])
        @updated = true
        sign_in(current_admin_user, :bypass => true)
      end
    end
    if current_admin_user.update(admin_user_params)
    end
  end

  def tournament
    @tournament_banner_name = params[:tournament_banner_id]
    @tournament_banner = Like.where(is_judged: true).joins(:post).where(post: { tournament_banner_id: params[:tournament_banner_id].present? ? params[:tournament_banner_id] : TournamentBanner&.first&.id, tournament_meme: true, flagged_by_user: [] })
      .group(:post_id).select('post_id, COUNT(CASE WHEN status = 1 THEN 1 END) AS likes, COUNT(CASE WHEN status = 2 THEN 1 END) AS dislikes').map { |record| [record.post_id, record.likes - record.dislikes] }.to_h.sort_by { |_, v| -v }.to_h
    ordered_ids = @tournament_banner.keys
    @posts = Post.where(id: ordered_ids).order(Arel.sql("array_position(ARRAY[#{ordered_ids.join(',')}], id)")).paginate(page: params[:page], per_page: 10)

    if params[:tournament_banner_id].present?
      @banner = TournamentBanner.find(params[:tournament_banner_id])
      session[:banner] = @banner
    else
      session[:banner] = TournamentBanner.first.present? ? TournamentBanner.first : ""
    end
  end

  def increase_post_like_count
    like = Like.new(post_id: params[:post_id] , user_id: '1', is_liked: true,is_judged: true,status: 1)
    like.save
    render json: { message: "Liked tournament Post" }, status: :ok
  end

  def decrease_post_like_count
    post_id = params[:post_id]
    like_to_delete = Like.where(post_id: post_id,is_liked: true).last
  
    if like_to_delete
      like_to_delete.destroy
      render json: { message: "Decreased like count for the post by one" }, status: :ok
    else
      render json: { error: "No like found for the specified post" }, status: :not_found
    end
  end

  # Dislike Post
  def increase_post_dislike_count
    like = Like.new(post_id: params[:post_id] , user_id: '1', is_liked: false,is_judged: true,status: 2)
    like.save
    render json: { message: "Disliked tournament Post" }, status: :ok
  end

  def decrease_post_dislike_count
    post_id = params[:post_id]
    like_to_delete = Like.where(post_id: post_id,is_liked: false).last
  
    if like_to_delete
      like_to_delete.destroy
      render json: { message: "Decreased like count for the post by one" }, status: :ok
    else
      render json: { error: "No like found for the specified post" }, status: :not_found
    end
  end

  def user_all_posts
    @posts = Post.where(user_id: params[:user_id])
    if @posts.present?
      posts_with_images = @posts.map do |post|
        {
          id: post.id,
          description: post.description,
          dislikes: post.likes.where(status: "dislike").count,
          likes: post.likes.where(is_judged: true).like.count,
          created_at: post.created_at.strftime('%b %d, %Y'),
          tournament_banner_id: post.tournament_banner_id,
          post_image: post.post_image.attached? ? post.post_image.blob.url : nil,
          image_type: post.post_image.content_type.split('/').first
        }   
      end
      render json: { posts: posts_with_images }
    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

  def delete_user_post
    @post = Post.find(params[:id])
    @post.destroy
    render json: { message: "Post Deleted Successfully." }, status: :ok
  end

  def user_tournament_posts
    @posts = Post.where(user_id: params[:user_id], tournament_banner_id: params[:tournament_banner_id])
    if @posts.present?
      posts_with_images = @posts.map do |post|
        {
          id: post.id,
          description: post.description,
          dislikes: post.likes.where(status: "dislike").count,
          likes: post.likes.where(is_judged: true).like.count,
          likes: post.likes.where(is_judged: true).like.count,
          created_at: post.user.tournament_users.first.created_at.strftime('%b %d, %Y'),
          tournament_banner_id: post.tournament_banner_id,
          post_image: post.post_image.attached? ? post.post_image.blob.url : nil,
          image_type: post.post_image.attached? ? post.post_image.content_type.split('/').first : ''
        }
      end
      render json: { posts: posts_with_images }
    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

 
  

  def tournament_banner
    @tournament_banner = TournamentBanner.order(start_date: :desc)
  end

  def tournament_banner_create
    @banner = TournamentBanner.new(banner_params)
    @banner.enable = true
    @banner.end_date = params[:end_date].to_date.end_of_day
    existing_active_tournament = TournamentBanner.where(enable: true)
      .where('start_date <= ? AND end_date >= ?', @banner.end_date, params[:start_date].to_date)
    if existing_active_tournament.exists?
      overlapping_tournament = existing_active_tournament.last
      flash[:alert] = "Cannot add another tournament because Tournament named 
                      #{overlapping_tournament.title} overlaps with the selected dates."
      redirect_to tournament_banner_path
    else
      if @banner.save
        @today_date = Time.zone.now.end_of_day.to_datetime
        @tournament_end_date = @banner.end_date.strftime("%a, %d %b %Y").to_datetime
        @tournamnet_days = (@tournament_end_date - @today_date).to_i
        # TournamentWorker.perform_in((Time.now + @tournamnet_days.days))
        # TournamentWorker.perform_in((Time.now + 1.minute))
        redirect_to tournament_banner_path
      end
    end
  end

  def tournament_banner_destroy
    @banner = TournamentBanner.find(params[:id])
    # SendJudgeCoinWorker.perform_in(Time.now, @banner.id)
    if @banner.destroy
      redirect_to tournament_banner_path
    end
  end

  def winner_detail
  end

  def tournament_winner_list
    if params[:coins].present? && params[:user_id].present?
      @user = User.find(params[:user_id])
      @user.update(coins: @user.coins + params[:coins].to_i)
      Notification.create(title: "Winner Coins",
                            body: "Congratulations you have won #{params[:coins].to_i} coins.",
                            user_id: params[:user_id],
                            sender_id: @current_admin_user.id,
                            sender_name: @current_admin_user.admin_user_name,
                            notification_type: 'tournament_winner',  
                            )
      UserMailer.winner_email_for_coin(@user,@user.email, params[:coins], params[:rank]).deliver_now
      flash.now.notice = "#{params[:coins]} coins sent to #{@user.username} successfully."
    end
    if params[:username].present?
      
      @user = User.find_by(username: params[:username])
      @user_image = @user.profile_image.attached? ?  @user.profile_image.blob.url : ActionController::Base.helpers.asset_path('user.png')
      @post = @user.posts.where(tournament_banner_id: session[:banner]["id"]).where(id: params[:post_id]).first
      @post_image = @post&.post_image&.attached? ? @post&.post_image&.blob&.url : ActionController::Base.helpers.asset_path('bg-img.jpg')
      @content_type = @post&.post_image&.present? ? @post&.post_image&.content_type&.split('/')&.first : ""
      respond_to do |format|
        format.json { render json: { user_image: @user_image, post_image: @post_image, content_type: @content_type } }
      end
    end
  end

  def winner_reward
    if params[:name].present? && params[:coins].present? && params[:card_number].present? && params[:tournament_winner].present?
      @gift_card = GiftReward.find_by(card_number: params[:card_number])
      if @gift_card.present?
        @gift_card.update(status: 1)
      end
      @user = User.find_by(username: params[:name])
      @user.update(coins: @user.coins + params[:coins].to_i)
      @tournament_winner = true
      UserMailer.winner_email(@user ,@user.email, params[:coins], params[:card_number], params[:rank]).deliver_now
    elsif params[:name].present? && params[:coins].present? && params[:card_number].present? && params[:tournament].present?
      @gift_card = GiftReward.find_by(card_number: params[:card_number])
      if @gift_card.present?
        @gift_card.update(status: 1)
      end
      @user = User.find_by(username: params[:name])
      @user.update(coins: @user.coins + params[:coins].to_i)
      @tournament_winner = false
      UserMailer.winner_email(@user ,@user.email, params[:coins], params[:card_number], params[:rank]).deliver_now
    end
    Notification.create(title: "Winner Coins",
                            body: "Congratulations you have won a gift card #{params[:card_number]} and #{params[:coins].to_i} coins.",
                            user_id: @user.id,
                            sender_id: @current_admin_user.id,
                            sender_name: @current_admin_user.admin_user_name,
                            notification_type: 'tournament_winner',  
                            )

    if @tournament_winner
      render json: { user_name: params[:name], coins: params[:coins], gift_card: params[:card_number] }
      # redirect_to tournament_winner_list_path
    else
      redirect_to tournament_path
    end
  end

  def flag_tournament_post
    @user = User.find(params[:user_id])
    puts "user email --------#{@user.inspect}"
    @post = Post.find_by(id: params[:post_id])
    @flagged = @post.flagged_by_user
    @flagged << @current_admin_user.id
    @post.update(flagged_by_user: @flagged, flag_message: 'Post flagged by admin') 
    UserMailer.flag_tournament_post(@user ,@user.email).deliver_now
    render json: { message: "Flagged Email Sent" }, status: :ok
  end

  def show_top_10
    @name, @email, @joined = [], [], []
    if params[:banner_id].present?
      @users = TournamentUser.find_by_sql("
                    SELECT ranked_users.*
                    FROM (
                      SELECT tu.*, 
                        user_ranks.max_rank,
                        ROW_NUMBER() OVER (PARTITION BY tu.user_id ORDER BY user_ranks.max_rank DESC) AS rn
                      FROM tournament_users tu
                      JOIN (
                        SELECT p.user_id, MAX(likes_count - dislikes_count) AS max_rank
                        FROM posts p
                        JOIN (
                          SELECT post_id, 
                            COUNT(CASE WHEN status = 1 THEN 1 END) AS likes_count, 
                            COUNT(CASE WHEN status = 2 THEN 1 END) AS dislikes_count
                          FROM likes
                          WHERE is_judged = true
                          GROUP BY post_id
                        ) AS like_dislike_counts
                        ON like_dislike_counts.post_id = p.id
                        WHERE p.tournament_banner_id = #{params[:banner_id]} 
                        AND p.tournament_meme = true
                        AND p.flagged_by_user.length == 0
                        GROUP BY p.user_id
                      ) AS user_ranks
                      ON user_ranks.user_id = tu.user_id
                    ) AS ranked_users
                    WHERE ranked_users.rn = 1
                    ORDER BY ranked_users.max_rank DESC
                    LIMIT 10
                  ")
      if @users.present?
        @users.each do |user|
          @name << user.user.username
          @email << user.user.email
          @joined << user.created_at.strftime("%F")
        end
        respond_to do |format|
          format.json { render json: { names: @name, emails: @email, joined: @joined } }
        end
      end
    end
  end

  def add_reward
    if params[:name].present? && params[:coins].present? && params[:card].present?
      @user = User.find_by(username: params[:name])
      if @user.present?
        @user.update(coins: @user.coins + params[:coins].to_i)
        UserMailer.reward_payout(@user,@user.email, params[:coins], params[:card]).deliver_now
        @gift_card = GiftReward.find_by(card_number: params[:card])
        if @gift_card.present?
          @gift_card.update(status: 1)
        end
        Notification.create(title: "Winner Coins",
                            body: "Congratulations you have won a gift card #{params[:card]} and #{params[:coins].to_i} coins.",
                            user_id: @user.id,
                            sender_id: @current_admin_user.id,
                            sender_name: @current_admin_user.admin_user_name,
                            notification_type: 'tournament_winner',  
                            )
        render json: { user_name: params[:name], coins: params[:coins], gift_card: params[:card] }
      end
    elsif params[:name].present? && params[:coins].present?
      @user = User.find_by(username: params[:name])
      if @user.present?
        @user.update(coins: @user.coins + params[:coins].to_i)
         Notification.create(title: "Winner Coins",
                            body: "Congratulations you have won #{params[:coins].to_i} coins.",
                            user_id: @user.id,
                            sender_id: @current_admin_user.id,
                            sender_name: @current_admin_user.admin_user_name,
                            notification_type: 'tournament_winner',  
                            )
        render json: { user_name: params[:name], coins: params[:coins] }
      end
    end
  end

  def post_images
    @user = User.find_by(username: params[:name])
    if @user.posts.where(tournament_banner_id: params[:banner_id], tournament_meme: true)[0].post_image.attached?
      @image = url_for(@user.posts.where(tournament_banner_id: params[:banner_id], tournament_meme: true)[0].post_image)
    else
      @image = ActionController::Base.helpers.asset_path('tr-1.jpg')
    end
    respond_to do |format|
      format.json { render json: { image: @image } }
    end
  end

  def get_user_post
    if params[:id].present?
      @user = User.find(params[:id].to_i)
      if @user.posts.present?
        @post_image = @user.posts.first.post_image.attached? ? @user.posts.first.post_image.blob.url : ActionController::Base.helpers.asset_path('bg-img.jpg')
        @likes = @user.posts.first.likes.where(status: "like").count
        @dislike = @user.posts.first.likes.where(status: "dislike").count
      else
        @post_image = ActionController::Base.helpers.asset_path('no_posts_yet.jpg')
        @likes = 0
        @dislike = 0
      end
    end
    respond_to do |format|
      format.json { render json: { post_image: @post_image, likes: @likes, dislike: @dislike } }
    end
  end

  def user_list
    if User.first.present?
      User.all.where(checked: true).update(checked: false)
    end
    @users = User.all.order("created_at DESC").paginate(page: params[:page], per_page: 10)
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    else
      @users = User.all.order("created_at DESC").paginate(page: params[:page], per_page: 10)
    end
  end

  def user_export
    if params[:user_id].present? && params[:checked].present? && params[:checked] == "true"
      @user = User.find(params[:user_id].to_i)
      if @user.present?
        @user.update(checked: true)
      end
    elsif params[:user_id].present? && params[:checked].present? && params[:checked] == "false"
      @user = User.find(params[:user_id].to_i)
      if @user.present?
        @user.update(checked: false)
      end
    end
    if User.first.present?
      @checked_user = User.all.where(checked: true)
    end
    if params[:search]
      @all_user = User.search(params[:search]).order("created_at DESC")
    else
      @all_user = User.all
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=users_list.csv"
      end
    end
  end

  def show_user_profile
    @user = User.all
    @badge_title, @badge_images = [], []
    @specific_user = User.find(params[:id])
    @image = @specific_user.profile_image.attached? ? @specific_user.profile_image.blob.url : ActionController::Base.helpers.asset_path('user.png')
    @badges = @specific_user.user_badges
    @badges.each do |user_badge|
      @badge_title << user_badge.badge.title
      if user_badge.badge.badge_image.attached?
        @badge_images << user_badge.badge.badge_image.blob.url
      else
        @badge_images << ActionController::Base.helpers.asset_path('user.png')
      end
    end
    @tournament_banners = []
    @tournament_banners = @specific_user.tournament_banners.present? ? @specific_user.tournament_banners.pluck(:title): []
    respond_to do |format|
      format.json { render json: { user: @user, image: @image, title: @badge_title, tournament_banners: @tournament_banners, badge_images: @badge_images } }
    end
  end

  def user_disable
    if params[:id].present?
      @user = User.find(params[:id])
      if @user.status == true
        @user.update(status: false, disabled: true)
      else
        @user.update(disabled: true)
      end
    end
  end

  def set_coins
    @daily_coins = DailyCoin.first_or_initialize(daily_coins_reward: "50")
    @daily_coins.save
    if params[:daily_coins_reward].present?
      @daily_coins.update(daily_coins_reward: params[:daily_coins_reward])
      redirect_to dashboard_path
    end
  end

  def user_enable
    if params[:id].present?
      @user = User.find(params[:id])
      @user.update(disabled: false, status: true)
    end
  end

  def gift_rewards
    @rewards = GiftReward.all.paginate(page: params[:page], per_page: 10)
    @amazon_cards = AmazonCard.all.paginate(page: params[:page], per_page: 10)
  end

  def update_card
    @card = AmazonCard.find(params[:id])
  end

  def transactions   
    if params[:search].present? && params[:start_date].present? && params[:end_date].present? && params[:start_date] != "false"
      @transactions_list = Transaction.search(params[:search])
      @transactions_list =  @transactions_list.date_filter(params[:start_date], params[:end_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10) if @transactions_list
    elsif params[:search].present? && params[:start_date].present? && params[:end_date] == "" && params[:start_date] != "false"
      @transactions_list = Transaction.search(params[:search])
      @transactions_list = @transactions_list.start_date_filter(params[:start_date]).search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 10) if @transactions_list
    elsif params[:search].present? && params[:end_date].present? && params[:start_date] == "" 
      @transactions_list = Transaction.search(params[:search])
      @transactions_list = @transactions_list.end_date_filter(params[:end_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10) if @transactions_list
    elsif params[:search].present? 
      @transactions_list = Transaction.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    elsif params[:start_date].present? && params[:end_date].present? && params[:start_date] != "false"
      @transactions_list = Transaction.date_filter(params[:start_date], params[:end_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    elsif params[:start_date].present? && params[:end_date] == "" && params[:start_date] != "false"
      @transactions_list = Transaction.start_date_filter(params[:start_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    elsif params[:start_date] == "" && params[:end_date].present?
      @transactions_list = Transaction.end_date_filter(params[:end_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    else
      @transactions_list = Transaction.order("id DESC").paginate(page: params[:page], per_page: 10)
    end
  end

  def transaction_export
    if params[:search].present? && params[:search] != ""
      @transactions_list = Transaction.search(params[:search]).order("created_at DESC")
    elsif params[:start_date].present? && params[:end_date].present? && params[:start_date] != "false"
      @transactions_list = Transaction.date_filter(params[:start_date], params[:end_date]).order("created_at DESC")
    elsif params[:start_date].present? && params[:end_date] == "" && params[:start_date] != "false"
      @transactions_list = Transaction.start_date_filter(params[:start_date]).order("created_at DESC")
    elsif params[:start_date] == "" && params[:end_date].present?
      @transactions_list = Transaction.end_date_filter(params[:end_date]).order("created_at DESC")
    else
      @transactions_list = Transaction.order("id DESC")
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=transactions_list.csv"
      end
    end
  end

  def specific_user_transactions
    @transactions = User.find(params[:user_id]).transactions
    @specific_user = User.find(params[:user_id])
    @image = @specific_user.profile_image.attached? ? @specific_user.profile_image.blob.url : ActionController::Base.helpers.asset_path('user.png')
    respond_to do |format|
      format.json { render json: { transaction: @transactions, image: @image } }
    end
  end

  def faqs
    @faqs = Faq.all
  end

  def faq_create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to faqs_path
    end
  end

  def faq_destroy
    @faq = Faq.find(params[:id])
    if @faq.destroy
      redirect_to faqs_path
    end
  end

  def faqs_edit
  end

  def faq_update
    @faqs = params[:faq]
    if @faqs != nil
      @faq = Faq.find(@faqs[:id])
      @faq.update(title: @faqs[:title], description: @faqs[:description])
      redirect_to faqs_path
    else
      @faqs = Faq.find(params[:id])
    end
  end

  def popup
    @popups = Popup.all
  end

  def popup_create
    @popup = Popup.new(faq_params)
    if @popup.save
      redirect_to pop_ups_path
    end
  end

  def popup_edit
  end

  def popup_destroy
    @pop_up = Popup.find(params[:id])
    if @pop_up.destroy
      redirect_to pop_ups_path
    end
  end

  def popup_update
    @popups = params[:popup]
    if @popups != nil
      @popup = Popup.find(@popups[:id])
      @popup.update(title: @popups[:title], description: @popups[:description])
      redirect_to pop_ups_path
    else
      @popups = Popup.find(params[:id])
    end
  end

  def privacy
    @privacy = Privacy.first_or_initialize(description: "Privacy Policies")
    @privacy.save
  end

  def privacy_edit
    @privacy_edit = Privacy.first_or_initialize
    if privacy_params.present?
      if @privacy_edit.update(privacy_params)
        redirect_to privacy_path
      end
    end
  end

  def terms
    @terms = Term.first_or_initialize(description: "Terms and Conditions")
    @terms.save
  end

  def terms_edit
    @terms_edit = Term.first_or_initialize
    if terms_params.present?
      if @terms_edit.update(terms_params)
        redirect_to terms_path
      end
    end
  end

  def support
    if params["/conversations"].present? && params["/conversations"][:subject].present?  && params["/conversations"][:subject] == 'All'
      @header_value = "All"
      @conversation = Conversation.includes(:messages).group("conversations.id", "messages.id").order("messages.created_at DESC").where.not(admin_user_id: nil)
    elsif params["/conversations"].present? && params["/conversations"][:subject].present?
      @message = Message.subjects[params["/conversations"][:subject]]
      @header_value = params["/conversations"][:subject]
      @conversation = Conversation.includes(:messages).where("messages.subject = ?", @message).group("conversations.id", "messages.id").order("messages.created_at DESC")
    else
      @conversation = Conversation.includes(:messages).group("conversations.id", "messages.id").order("messages.created_at DESC").where.not(admin_user_id: nil)
      @header_value = "Select Subject"
    end
  end

  def follower_count
    @user_id = User.find(params[:user_id])
    @follower_count = @user_id.followers.count
    @following_count = @user_id.followers.where(status: "pending").count
    @posts_count = @user_id.posts.count
    respond_to do |format|
      format.json { render json: { followers: @follower_count, following: @following_count, posts: @posts_count } }
    end
  end

  def getGiftCardRequest
    @gift_card_requests = GiftCardRequest.all
    render json: @gift_card_requests
  end

  def send_gift_card
    @user = User.find_by(email: params[:email])
    request = GiftCardRequest.find_by(id: params[:requestId])
    if request && @user.coins >= request.coins
      request.update(status: 1)
      UserMailer.amazon_purshase_card(@user, params[:card_number], params[:coins]).deliver_now
      coins_to_subtract = params[:coins].to_i
      @user.update(coins: @user.coins - coins_to_subtract)
      render json: { message: "Gift Card Sent Via Email" }, status: :ok
    else 
        render json: { message: "Failed to send Gift Card" }, status: :unprocessable_entity
    end
    
    
  end
  

  private

  def admin_user_params
    params.permit(:admin_profile_image)
  end

  def terms_params
    params.permit(:description)
  end

  def privacy_params
    params.permit(:description)
  end

  def faq_params
    params.permit(:title, :description)
  end

  def banner_params
    params.permit(:title, :start_date, :end_date, :tournament_banner_photo)
  end
end
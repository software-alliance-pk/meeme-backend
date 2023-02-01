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
      AdminUser.create(email: params[:email], full_name: params[:full_name], admin_user_name: params[:admin_user_name], password: params[:password])
      redirect_to dashboard_path
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
    if params[:password] == "" && params[:admin_profile_image] == nil && params[:full_name].present? && params[:admin_user_name]
      # current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name])
      # @updated = true
      if AdminUser.first.present?
        if params[:full_name] == AdminUser.first.full_name && params[:admin_user_name] == AdminUser.first.admin_user_name
          @updated = false
        else
          current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name])
          @updated = true
        end
      end
    elsif params[:password] != nil && params[:password] != params[:password_confirmation]
      @updated = false
      redirect_to admin_profile_path
    elsif params[:password] != nil && params[:password] == params[:password_confirmation] && current_admin_user.valid_password?(params[:old_password])
      current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name], password: params[:password])
      @updated = true
      sign_in(current_admin_user, :bypass => true)
    end
    if current_admin_user.update(admin_user_params)
    end
  end

  def tournament
    @tournament_banner_name = params[:tournament_banner_id]
    @tournament_banner = Like.where(is_judged: true, status: 'like').joins(:post).where(post: { tournament_banner_id: params[:tournament_banner_id].present? ? params[:tournament_banner_id] : TournamentBanner&.first&.id, tournament_meme: true }).
      group(:post_id).count(:post_id).sort_by(&:last).sort_by(&:last).reverse.to_h
    @posts = Post.where(id: @tournament_banner.keys).joins(:likes).group("posts.id").order('COUNT(likes.id) DESC').paginate(page: params[:page], per_page: 10)
    if params[:tournament_banner_id].present?
      @banner = TournamentBanner.find(params[:tournament_banner_id])
      session[:banner] = @banner
    else
      session[:banner] = TournamentBanner.first.present? ? TournamentBanner.first : ""
    end
  end

  def tournament_banner
    @tournament_banner = TournamentBanner.all
  end

  def tournament_banner_create
    @banner = TournamentBanner.new(banner_params)
    @banner.enable = true
    if TournamentBanner.count == 0
      if @banner.save
        rule = @banner.build_tournament_banner_rule(rules: ["Abusing is not Allowed"])
        rule.save
        @today_date = Time.zone.now.end_of_day.to_datetime
        @tournament_end_date = @banner.end_date.strftime("%a, %d %b %Y").to_datetime
        @tournamnet_days = (@tournament_end_date - @today_date).to_i
        TournamentWorker.perform_in((Time.now + @tournamnet_days.days), @banner.id)
        # TournamentWorker.perform_in((Time.now + 1.minute), @banner.id)

        redirect_to tournament_banner_path
      end
    else
      flash[:alert] = "There can be only one banner at a time"
      redirect_to tournament_banner_path
    end
  end

  def tournament_banner_destroy
    @banner = TournamentBanner.find(params[:id])
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
      UserMailer.winner_email_for_coin(@user.email, params[:coins], params[:rank]).deliver_now
    end
    if params[:username].present?
      @user = User.find_by(username: params[:username])
      @user_image = @user.profile_image.attached? ? url_for(@user.profile_image) : ActionController::Base.helpers.asset_path('user.png')
      @post = @user.posts.where(tournament_banner_id: session[:banner]["id"])
      @post_image = @post[0].post_image.attached? ? url_for(@post[0].post_image) : ActionController::Base.helpers.asset_path('bg-img.jpg')
      respond_to do |format|
        format.json { render json: { user_image: @user_image, post_image: @post_image } }
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
      UserMailer.winner_email(@user.email, params[:coins], params[:card_number], params[:rank]).deliver_now
    elsif params[:name].present? && params[:coins].present? && params[:card_number].present? && params[:tournament].present?
      @gift_card = GiftReward.find_by(card_number: params[:card_number])
      if @gift_card.present?
        @gift_card.update(status: 1)
      end
      @user = User.find_by(username: params[:name])
      @user.update(coins: @user.coins + params[:coins].to_i)
      @tournament_winner = false
      UserMailer.winner_email(@user.email, params[:coins], params[:card_number], params[:rank]).deliver_now
    end
    if @tournament_winner
      redirect_to tournament_winner_list_path
    else
      redirect_to tournament_path
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
      format.json { render json: { post_image: @post_image, likes: @likes, dislike: @dislike} }
    end
  end

  def user_list
    if User.first.present?
      User.all.where(checked: true).update(checked: false)
    end
    @users = User.paginate(page: params[:page], per_page: 10)
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    else
      @users = User.paginate(page: params[:page], per_page: 10)
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
    @image = @specific_user.profile_image.attached? ? url_for(@specific_user.profile_image) : ActionController::Base.helpers.asset_path('user.png')
    @badges = @specific_user.user_badges
    @badges.each do |user_badge|
      @badge_title << user_badge.badge.title
      if user_badge.badge.badge_image.attached?
        @badge_images << url_for(user_badge.badge.badge_image)
      else
        @badge_images << ActionController::Base.helpers.asset_path('user.png')
      end
    end
    respond_to do |format|
      format.json { render json: { user: @user, image: @image, title: @badge_title, badge_images: @badge_images } }
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
      @user.update(disabled: false)
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
    if params[:search]
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
      @transactions_list = Transaction.date_filter(params[:start_date], params[:end_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    elsif params[:start_date].present? && params[:end_date] == "" && params[:start_date] != "false"
      @transactions_list = Transaction.start_date_filter(params[:start_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
    elsif params[:start_date] == "" && params[:end_date].present?
      @transactions_list = Transaction.end_date_filter(params[:end_date]).order("created_at DESC").paginate(page: params[:page], per_page: 10)
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
    @image = @specific_user.profile_image.attached? ? url_for(@specific_user.profile_image) : ActionController::Base.helpers.asset_path('user.png')
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
    if @privacy_edit.update(privacy_params)
    end
  end

  def terms
    @terms = Term.first_or_initialize(description: "Terms and Conditions")
    @terms.save
  end

  def terms_edit
    @terms_edit = Term.first_or_initialize
    if @terms_edit.update(terms_params)
    end
  end

  def support
    if params["/conversations"].present? && params["/conversations"][:subject].present?
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
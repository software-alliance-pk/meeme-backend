require 'csv'

class DashboardController < ApplicationController

  def dashboard
    @user = User.order("id DESC").limit(4)
  end

  def welcome
  end

  def homepage
    if admin_user_signed_in?
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
  end

  def forgot_password
  end

  def reset_password
  end

  def verification
  end

  def notifications
  end

  def admin_profile
    if params[:password] == ""
      current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name], email: params[:email])
    elsif params[:password] != nil && params[:password] != params[:password_confirmation]
      redirect_to admin_profile_path
    elsif params[:password] != nil && params[:password] == params[:password_confirmation]
      current_admin_user.update(full_name: params[:full_name], admin_user_name: params[:admin_user_name], email: params[:email], password: params[:password])
    end
  end

  def tournament
    @id, @name, @email, @likes, @dislikes, @created, @image, @participated = [], [], [], [], [], [], [], []
    @tournament_banner = Like.where(is_judged:true, status: 'like').joins(:post).where(post: { tournament_banner_id: params[:tournament_banner_id], tournament_meme: true }).
      group(:post_id).count(:post_id).sort_by(&:last).sort_by(&:last).reverse.to_h
    @posts = Post.where(id: @tournament_banner.keys).joins(:likes).group("posts.id").order('COUNT(likes.id) DESC')
    @tormnt_participated = Post.where(id: @tournament_banner.keys)
    if @posts != []
      @banner = TournamentBanner.find(params[:tournament_banner_id])
      @banner.end_date.strftime('%b,%d,%y') > Time.now.strftime('%b,%d,%y') ? @status = "ongoing" : @status = "finished"
      @joined = @banner.tournament_users.count
      @participated = @tormnt_participated.joins(:likes).group("user_id").count
      @posts.each do |post|
        @id << post.user.id
        @name << post.user.username
        @email << post.user.email
        @likes << post.likes.where(is_judged: true).like.count
        @dislikes << post.likes.where(is_judged: true).dislike.count
        @created << post.user.tournament_users.first.created_at.strftime('%b,%d,%y')
        @image << post.post_image.attached? ? post.post_image.blob : ActionController::Base.helpers.image_tag("tr-1.jpg")
      end
      respond_to do |format|
        format.json {render json: {id: @id, name: @name, email: @email, likes: @likes, dislikes: @dislikes, created: @created, image: @image, participated: @participated, status: @status}}
      end
    end
  end

  # def tournament_users
  #   @tournament = TournamentBanner.find(params[:tournament_banner_id])
  #   @tournament_banner_user = @tournament.tournament_users
  #   @tournament_users_details = @tournament.users
  #   @joined_users_count = @tournament.users.count
  #   respond_to do |format|
  #     format.json {render json: {tournament: @tournament ,tournament_users: @tournament_banner_user ,users: @tournament_users_details, users_count: @joined_users_count}}
  #   end

  # end

  def tournament_banner
    @tournament_banner= TournamentBanner.all
  end

  def tournament_banner_create
    @banner = TournamentBanner.new(banner_params)
    if @banner.save
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

  end
  def user_list
    @users = User.paginate(page: params[:page ] ,per_page: 10)
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page ] ,per_page: 10)
    else
      @users = User.paginate(page: params[:page ] ,per_page: 10)
    end
  end

  def user_export
    @all_user = User.all
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=users_list.csv"
      end
    end
  end

  def show_user_profile
    @user = User.all
    respond_to do |format|
      format.json {render json: @user}
    end
  end

  def gift_rewards
  end

  def transactions
    if params[:search]
      @transactions_list = Transaction.search(params[:search]).order("created_at DESC").paginate(page: params[:page ] ,per_page: 10)
    else
      @transactions_list = Transaction.order("id DESC").paginate(page: params[:page ] ,per_page: 10)
    end
  end

  def transaction_export
    @transactions_list = Transaction.all
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=transactions_list.csv"
      end
    end
  end

  def specific_user_transactions
    @transactions = User.find(params[:user_id]).transactions
    respond_to do |format|
      format.json {render json: @transactions}
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
  end

  def follower_count
    @user_id = User.find(params[:user_id])
    @follower_count = @user_id.followers.count
    @following_count = @user_id.followers.where(status: "pending").count
    @posts_count = @user_id.posts.count
    respond_to do |format|
      format.json {render json: {followers: @follower_count, following: @following_count, posts: @posts_count}}
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

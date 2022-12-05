class Api::V1::FollowersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :not_following_himself, except: %i[index show_pending_requests]
  before_action :already_following, except: %i[index show_pending_requests update_follower un_follow_user]
  before_action :find_user, except: %i[index show_pending_requests show_people]

  # GET /users
  def index
    @user_followers = @current_user.followers.where(is_following: true, status: "added").paginate(page: params[:page], per_page: 25)
    if @user_followers.present?
      render json: { followers_count: @user_followers.count, followers: @user_followers }, status: :ok
    else
      render json: { followers: @user_followers }, status: :not_found
    end
  end

  def show_pending_requests
    @user_followers = @current_user.pending_friend_request.paginate(page: params[:page], per_page: 25)
    if @user_followers.present?
    else
      render json: { followers: @user_followers }, status: :ok
    end
  end

  def create
    @follower = Follower.new(user_id: @current_user.id, is_following: true, follower_user_id: params[:follower_user_id], status: 'added')
    if @follower.save
      render json: { user: @current_user, follower: @follower, message: "#{@current_user.username} and #{User.find_by(id: @follower.follower_user_id).username} are now friends" }, status: :ok
    else
      render_error_messages(@follower)
    end
  end

  def send_a_follow_request_to_user
    @follower = Follower.where(user_id: @current_user.id, is_following: false, follower_user_id: params[:follower_user_id], status: 'pending')
    if @follower.present?
      render json: { message: "Request already sent a request" }, status: :ok
      @follower = Follower.new(user_id: @current_user.id, is_following: false, follower_user_id: params[:follower_user_id], status: 'pending')
      if @follower.save
        render json: { user: @current_user, follower: @follower, message: "#{@current_user.username} sent a request to #{User.find_by(id: @follower.follower_user_id).username} " }, status: :ok
      else
        @follower = Follower.new(user_id: @current_user.id, is_following: false, follower_user_id: params[:follower_user_id], status: 'pending')
        if @follower.save
          render json: { user: @current_user, follower: @follower, message: "#{@current_user.username} sent a request to #{User.find_by(id: @follower.follower_user_id).username} " }, status: :ok
        else
          render_error_messages(@follower)
        end
      end
    end
  end

  def update_follower
    @follower = Follower.find_by(user_id: params[:follower_user_id], follower_user_id: @current_user.id)
    if @follower.present?
      if @follower.is_following.to_s == params[:is_following] && @follower.added?
        render json: { message: "User unfriend his follower" }, status: :ok
      elsif @follower.is_following.to_s == params[:is_following] && @follower.pending?
        @follower.destroy
        render json: { message: "User removed from pending" }, status: :ok
      else
        @follower.update(is_following: true, status: 'added')
        render json: { message: "User added this follower", request: @follower }, status: :ok
      end
    else
      render json: { message: "The don't follow each other" }, status: :not_found
    end
  end

  def un_follow_user
    @follower = Follower.find_by(user_id: @current_user.id, follower_user_id: params[:follower_user_id])
    if @follower.present?
      if @follower.un_followed!
        @follower.destroy
        render json: { message: "User un-followed" }, status: :ok
      else
        render json: { message: "Could not process the request" }, status: :ok
      end
    else
      render json: { message: "The don't follow each other" }, status: :not_found
    end
  end

  def show_people
    users = @current_user.followers.where(is_following: false).pluck(:follower_user_id)
    users = users.push(@current_user.id)
    users = User.where.not(id: users).paginate(page: params[:page], per_page: 25)
    if users.present?
      render json: { people_count: users.count, people_not_added: users }, status: :ok
    else
      render json: { people_count: users.count, people_not_added: users }, status: :ok
    end
  end

  private

  def find_user
    unless (@user = User.find_by(id: params[:follower_user_id]))
      return render json: { message: 'User Not found' }, status: :not_found
    end
  end

  def already_following
    return render json: { message: 'Already Following Each Other' } if (Follower.find_by(user_id: @current_user.id, is_following: true, follower_user_id: params[:follower_user_id]))
  end

  def not_following_himself
    return render json: { message: 'You cannot follow yourself' } if (@current_user.id == params[:follower_user_id].to_i)
  end

end
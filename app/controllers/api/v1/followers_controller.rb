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
      @follower = Follower.create!(follower_user_id: @current_user.id, is_following: true, user_id: params[:follower_user_id], status: 'added')
    else
      render_error_messages(@follower)
    end
  end

  def send_a_follow_request_to_user
    @secondary_follower = Follower.where(follower_user_id: @current_user.id, is_following: false, user_id: params[:follower_user_id], status: 'pending')
    @follower = Follower.where(user_id: @current_user.id, is_following: false, follower_user_id: params[:follower_user_id], status: 'pending')
    if @follower.present?
      render json: { message: "Request already sent a request" }, status: :ok
    else
      @follower = Follower.new(user_id: @current_user.id, is_following: false, follower_user_id: params[:follower_user_id], status: 'pending')
      if @follower.save
        Notification.create(title: "Friend Request",
                            body: "#{@current_user.username} follows you",
                            follow_request_id: @follower.id,
                            user_id: params[:follower_user_id])
        
        render json: { user: @current_user, follower: @follower, message: "#{@current_user.username} sent a follow request to #{User.find_by(id: @follower.follower_user_id).username} " }, status: :ok
        @secondary_follower = Follower.create!(follower_user_id: @current_user.id, is_following: false, user_id: params[:follower_user_id], status: 'pending')
      else
        render_error_messages(@follower)
      end
    end
  end

  def update_follower
    @secondary_follower=Follower.find_by(follower_user_id: params[:follower_user_id], user_id: @current_user.id)
    @follower = Follower.find_by(user_id: params[:follower_user_id], follower_user_id: @current_user.id)
    if @follower.present?
      if @follower.is_following.to_s == params[:is_following] && @follower.added?
        render json: { message: "User unfriend his follower" }, status: :ok
      elsif @follower.is_following.to_s == params[:is_following] && @follower.pending?
        # Notification.create(title: "Request Rejected",
        #                     body: "Follower request has been rejected by #{@current_user.username}",
        #                     follow_request_id: @follower.id,
        #                     user_id: params[:follower_user_id])
        @follower.destroy
        @secondary_follower.destroy
        render json: { message: "User removed from pending" }, status: :ok
      else
        @follower.update(is_following: true, status: 'added')
        @secondary_follower.update(is_following: true, status: 'added')
        Notification.create(title: "Request Accepted",
                            body: "Follower request has been accepted by #{@current_user.username}",
                            follow_request_id: @follower.id,
                            user_id: params[:follower_user_id])
        render json: { message: "User added this follower", request: @follower }, status: :ok
      end
    else
      render json: { message: "The don't follow each other" }, status: :not_found
    end
  end

  def un_follow_user
    @secondary_follower = Follower.find_by(follower_user_id: @current_user.id, user_id: params[:follower_user_id])
    @follower = Follower.find_by(user_id: @current_user.id, follower_user_id: params[:follower_user_id])
    if @follower.present?
      if @follower.un_followed!
        @follower.destroy
        @secondary_follower.destroy
        render json: { message: "#{User.find_by(id: @follower.follower_user_id).username} has been unfollowed" }, status: :ok
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
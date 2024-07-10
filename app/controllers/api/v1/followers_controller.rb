class Api::V1::FollowersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :not_following_himself, except: %i[index show_pending_requests]
  before_action :already_following, except: %i[index show_pending_requests update_follower un_follow_user cancel_follow_request]
  before_action :find_user, except: %i[index show_pending_requests show_people suggestions cancel_follow_request]

  # GET /users
  def index
    if params[:key] == 'followers'
      @user_followers = @current_user.followers.where(user_id: @current_user.id, status: "follower_added").paginate(page: params[:page], per_page: 25)
      return render json: { message: 'No Followers Present', followers: [] }, status: :ok unless @user_followers.present?
    elsif params[:key] == 'followings'
      @user_followings = @current_user.followings.where(follower_user_id: @current_user.id, status: "following_added").paginate(page: params[:page], per_page: 25)
      return render json: { message: 'You are not following any user', followings: [] }, status: :ok unless @user_followings.present?
    end
  end

  def show_pending_requests
    @user_followers = @current_user.followers.pending.paginate(page: params[:page], per_page: 25)
    if @user_followers.present?
    else
      render json: { followers: @user_followers }, status: :ok
    end
  end

  def create
    @follower = Follower.new(user_id: @current_user.id, is_following: true, follower_user_id: params[:follower_user_id], status: 'follower_added')
    if @follower.save
      render json: { user: @current_user, follower: @follower, message: "#{@current_user.username} and #{User.find_by(id: @follower.follower_user_id).username} are now friends" }, status: :ok
      @follower = Follower.create!(follower_user_id: params[:follower_user_id], is_following: true, user_id: @current_user.id , status: 'following_added')
    else
      render_error_messages(@follower)
    end
  end

  def send_a_follow_request_to_user
    @follower = Follower.where(follower_user_id: @current_user.id, is_following: false, user_id: params[:follower_user_id], status: 'pending')
    if @follower.present?
      render json: { message: "Request already sent a request" }, status: :ok
    else
      # is_following set to true
      @follower = Follower.new(follower_user_id: @current_user.id, is_following: true, user_id: params[:follower_user_id], status: 'pending')
      @user = User.find_by(id: params[:follower_user_id])
      if @follower.save
        if @user.private_account?
          send_notification('Friend Request', @current_user, "#{@current_user.username} wants to follows you",@follower.id, params[:follower_user_id], 'request_send')
          render json: { user: @current_user, is_private: @user.private_account, follower: @follower, message: "#{@current_user.username} sent a follow request to #{User.find_by(id: @follower.user_id).username} " }, status: :ok
        else
          @follower.update(status: 'following_added')
          Follower.create(user_id: params[:follower_user_id], is_following: true ,follower_user_id: @current_user.id, status: "follower_added")
          send_notification('Started Following', @current_user, "#{@current_user.username} started following you" , @follower.id, params[:follower_user_id], 'request_send')
          render json: { user: @current_user, is_private: @user.private_account, follower: @follower, message: "#{@current_user.username} started following #{User.find_by(id: @follower.user_id).username} " }, status: :ok
        end
      else
        render_error_messages(@follower)
      end
    end
  end

  def update_follower
    @follower = Follower.find_by(follower_user_id: params[:follower_user_id], user_id: @current_user.id)
    if @follower.present?
      if @follower.is_following.to_s == params[:is_following] && @follower.follower_added?
        render json: { message: 'User unfriend his follower' }, status: :ok
      elsif @follower.is_following.to_s == params[:is_following] && @follower.pending?
        Notification.create(title: 'Request Rejected',
                            body: "Follower request has been rejected by #{@current_user.username}",
                            follow_request_id: @follower.id,
                            user_id: params[:follower_user_id])
        @follower.destroy
        render json: { message: 'User removed from pending' }, status: :ok
      else
        @follower.update(is_following:true, status: 'follower_added')
        Follower.create(user_id: @current_user.id, is_following: true ,follower_user_id: params[:follower_user_id], status: "following_added")
        send_notification('Request Accepted', @current_user, "Follower request has been accepted by #{@current_user.username}" , @follower.id, params[:follower_user_id], 'request_accepted')
        render json: { message: "User added this follower", request: @follower }, status: :ok
      end
    else
      render json: { message: "The don't follow each other" }, status: :not_found
    end
  end

  def send_notification(title, current_user, body ,follower_id, follower_user_id, notification_type)
    Notification.create(title: title,
                        body: body,
                        follow_request_id: follower_id,
                        user_id: follower_user_id,
                        notification_type: notification_type,
                        sender_id: current_user.id,
                        sender_name: current_user.username)
  end

  def un_follow_user
    @follower = Follower.find_by(follower_user_id: @current_user.id, user_id: params[:follower_user_id], status: 'follower_added')
    @following = Follower.find_by(follower_user_id: @current_user.id, user_id: params[:follower_user_id], status: 'following_added')
    if @follower.present? && @following.present?
      @follower.destroy
      @following.destroy
      render json: { message: "#{User.find_by(id: @follower.user_id).username} has been unfollowed" }, status: :ok
    else
      render json: { message: "They don't follow each other" }, status: :not_found
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

  def suggestions
    # followers=@current_user.followers.pluck(:follower_user_id)
    # followings=@current_user.followings.pluck(:user_id)
    # excluded << @current_user.id
    excluded=((@current_user.followers.pluck(:follower_user_id)+@current_user.followings.pluck(:user_id))<< @current_user.id).uniq
    @users=User.where.not(id: excluded).shuffle.paginate(page: params[:page], per_page: 25)
    if @users.present?
    else
      return render json: { suggestions: [] }, status: :ok
    end
  end

  def cancel_follow_request
    @request = Follower.find_by(follower_user_id: @current_user.id, user_id: params[:follower_user_id], status: 'pending')
    return render json: { message: 'Not Requested' }, status: :not_found unless @request.present?

    @request.destroy
    render json: { message: 'Request Cancel Successfully' }, status: :ok
  end

  private

  def find_user
    unless (@user = User.find_by(id: params[:follower_user_id]))
      return render json: { message: 'User Not found' }, status: :not_found
    end
  end

  def already_following
    return render json: { message: 'Already Following Each Other' } if (Follower.find_by(user_id: params[:follower_user_id], follower_user_id: @current_user.id))
  end

  def not_following_himself
    return render json: { message: 'You cannot follow yourself' } if (@current_user.id == params[:follower_user_id].to_i)
  end

end
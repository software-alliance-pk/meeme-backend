class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_request, except: %i[verify_otp create forgot_password reset_user_password email_validate get_sender_details delete_user]
  before_action :find_user, except: %i[create index update_user all_posts open_current_user email_validate active_status_change notification_settings private_account delete_user search]
  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def open_current_user

  end

  def open_some_other_user
  end

  def all_posts
    @posts = Post.where(tournament_meme: false).order('updated_at DESC').paginate(page: params[:page], per_page: 25)
  end

  def search
    username = params[:username]
    similar_users = User.where('lower(username) LIKE ?', "%#{username.downcase}%")
    render json: { similar_users: similar_users }
  end

  def get_sender_details
    sender = User.find(params[:id])
    render json: { username: sender.username, email: sender.email }
  end

  def update_user_theme
    if params[:theme].present?
      if @user.update(user_themes: params[:theme])
        render json: { message: 'User theme updated successfully' }, status: :ok
      else
        render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    elsif params[:font].present?
      if @user.update(font: params[:font])
        render json: { message: 'User font updated successfully' }, status: :ok
      else
        render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    elsif params[:backgroung_image].present?
      if @user.update(backgroung_image: params[:backgroung_image])
        render json: { message: 'User backgroung image updated successfully' }, status: :ok
      else
        render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      render json: { error: "Please provide theme or font or background image." }, status: :unprocessable_entity
    end
  end


  def delete_user
    user_id = params[:user_id]
    user = User.find_by(id: user_id)
    if user.nil?
      return render json: { error: 'User not found' }, status: :not_found
    end
    conversations = Conversation.where(sender_id: user_id).or(Conversation.where(receiver_id: user_id))
    conversations.destroy_all;
    user.destroy
    return render json: { url: "#{ENV['BACKEND_URL']}/deletion" , confirmation_code: 786734 }, status: :ok
  end
  

  def open_profile
    @profile = User.find_by(id: params[:id])
    return render json: { message: "User not found" }, status: :not_found unless @profile
  end

  # # GET /users/{username}
  # def show
  #   render json: { user: @user,
  #                  profile_image: @user.profile_image.attached? ? @user.profile_image.blob.url : '' },
  #          status: :ok
  # end

  # POST /users
  def create
      @user = User.new(user_params)
      if @user.save
        render json: { user: @user,
                       profile_image: @user.profile_image.attached? ? @user.profile_image.blob.url : '',
                       wallet: @user.get_wallet,
                       message: 'User created successfully' }, status: :ok
        MobileDevice.find_or_create_by(mobile_token: params[:mobile_token], user_id: @user.id)
      else
        render_error_messages(@user)
      end
  end
  

  def email_validate
    if User.exists?(username: params[:username])
      render json: { username: 'Username already taken', username_status: true }, status: :ok
    else
      @user = User.find_by_email(params[:email])
      if @user.present?
        return render json: { message: 'Email present', email_status: true }, status: :ok
      else
        return render json: { message: 'Email not present', email_status: false }, status: :not_found
      end
   end
  end

  # PUT /users/{username}
  def update_user
    unless @current_user.update(user_params)
      render_error_messages(@user)
    else
      @current_user.update(user_params)
      render json: { user: @current_user,
                     profile_image: @current_user.profile_image.attached? ? @current_user.profile_image.blob.url : '',
                     message: "Profile Updated" },
             status: :ok
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
    render json: { message: 'User Successfully Deleted' }, status: :ok
  end

  def forgot_password
    @otp_generate = 4.times.map { rand(10) }.join
    @user.update(otp: @otp_generate)
    if UserMailer.user_forgot_password(@user.email, @otp_generate).deliver_now
      return render json: { message: 'OTP is sent successfully', otp: @otp_generate }, status: :ok
    else
      return render json: { message: 'OTP was not  send successfully' }, status: :unprocessable_entity
    end
  end

  def forgot_password_web
    @otp_generate = 4.times.map { rand(10) }.join
    @user.update(otp: @otp_generate)
    if UserMailer.user_forgot_password_web(@user.email, @otp_generate).deliver_now
      return render json: { message: 'OTP is sent successfully', otp: @otp_generate }, status: :ok
    else
      return render json: { message: 'OTP was not  send successfully' }, status: :unprocessable_entity
    end
  end

  def verify_otp
    if @user.otp == params[:otp]
      if @user.updated_at < 1.minute.ago
        @user.update(otp: nil)
        return render json: { message: "OTP expired", user_otp: @user.otp, otp: params[:otp] }, status: :unprocessable_entity
      else
        @user.update(otp: nil)
        return render json: { message: "Correct OTP", user_otp: @user.otp, otp: params[:otp] }, status: :ok
      end
    else
      return render json: { message: "OTP is not valid", user_otp: @user.otp, otp: params[:otp] }, status: :unprocessable_entity
    end
  end

  def active_status_change
    if params[:status] == "false"
      @current_user.update(status: false)
      return render json: { message: "Active Status Changed", user_status: @current_user.status }, status: :ok
    end
    if params[:status] == "true"
      @current_user.update(status: true)
      return render json: { message: "Active Status Changed", user_status: @current_user.status }, status: :ok
    end
    if params[:status].empty? || params[:status] != "false" || params[:status] != "true"
      return render json: { message: "Empty or Invalid parameters", user_status: @current_user.status }, status: :ok
    end
  end

  def reset_user_password
    return render json: { message: 'Email cannot be empty' }, status: :unprocessable_entity if params[:email].empty?

    return render json: { message: 'User with Email not found' }, status: :unprocessable_entity unless @user

    return render json: { message: 'Password not present' }, status: :unprocessable_entity if params[:password].empty?

    return render json: { message: 'Confirm Password not present' }, status: :unprocessable_entity if params[:password_confirmation].empty?
    if params[:password] == params[:password_confirmation]
      @user.update(password: params[:password], otp: nil)
      render json: { message: "Password updated" }, status: :ok
    else
      render json: { message: "Passwords don't match" }, status: :not_found
    end
  end

  def notification_settings
    if params[:notification_alert] == ""
      render json: { notification: @current_user.notifications_enabled? }, status: :ok
    end
    if params[:notification_alert] == true.to_s
      @current_user.notifications_enabled!
      render json: { message: "Notifications On", notification: @current_user.notifications_enabled? }, status: :ok
    end
    if params[:notification_alert] == false.to_s
      @current_user.notifications_disabled!
      render json: { message: "Notifications Off", notification: @current_user.notifications_enabled? }, status: :ok
    end
  end

  def private_account
    if params[:is_private].present?
      @current_user.update(private_account: params[:is_private])
      render json: { is_private: @current_user.private_account }, status: :ok
    end
  end

  private

  def find_user
    unless (@user = User.find_by_email(params[:email]) || User.find_by_id(params[:id]))
      return render json: { message: 'User Not found' }, status: :not_found
    end
  end

  def user_params
    params.permit(:username, :email, :phone, :bio, :password, :password_confirmation, :profile_image, :status
    )
  end
end

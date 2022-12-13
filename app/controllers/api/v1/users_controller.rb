class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_request, except: %i[create forgot_password reset_user_password email_validate verify_otp]
  before_action :find_user, except: %i[create index update_user all_posts open_current_user email_validate]
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

  def open_profile
    @profile = User.find_by(id: params[:id])
    return render json: { message: "User not found" }, status: :not_found unless @profile
  end

  # GET /users/{username}
  def show
    render json: { user: @user,
                   profile_image: @user.profile_image.attached? ? @user.profile_image.blob.url : '' },
           status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { user: @user,
                     profile_image: @user.profile_image.attached? ? @user.profile_image.blob.url : '',
                     wallet: @user.get_wallet,
                     message: 'User created successfully' }, status: :ok
    else
      render_error_messages(@user)
    end
  end

  def email_validate
    @user = User.find_by_email(params[:email])
    if @user.present?
      return render json: { message: 'Email present', email_status: true }, status: :ok
    else
      return render json: { message: 'Email not present', email_status: false }, status: :not_found
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
  end

  def forgot_password
    @otp_generate = 4.times.map { rand(10) }.join
    @user.update(otp: @otp_generate)
    if UserMailer.user_forgot_password(@user.email, @otp_generate).deliver_now
      return render json: { message: 'OTP is sent successfully', otp: @otp_generate }, status: :ok
    else
      return render json: { message: 'OTP was not send successfully' }, status: :unprocessable_entity
    end
  end

  def verify_otp
    if @user.otp == params[:otp]
      if @user.updated_at < 1.minute.ago
        @user.update(otp: nil)
        return render json: { message: "Otp expired" }, status: :unprocessable_entity
      else
        return render json: { message: "Correct Otp", otp: params[:otp] }, status: :ok
      end
    else
      return render json: { message: "Otp is not valid" }, status: :unprocessable_entity
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

  private

  def find_user
    unless (@user = User.find_by_email(params[:email]) || User.find_by_id(params[:id]))
      return render json: { message: 'User Not found' }
    end
  end

  def user_params
    params.permit(:username, :email, :phone, :bio, :password, :password_confirmation, :profile_image
    )
  end
end

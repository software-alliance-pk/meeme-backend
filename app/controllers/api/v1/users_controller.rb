class Api::V1::UsersController <  Api::V1::ApiController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index update_user forgot_password reset_user_password]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    render json: {user: @user,
                  profile_image: @user.profile_image.attached? ? rails_blob_path(@user.profile_image): ''},
           status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { user: @user, profile_image: @user.profile_image.attached? ? rails_blob_path(@user.profile_image): '',message: 'User created successfully'}, status: :created
    else
      render_error_messages(@user)
    end
  end

  # PUT /users/{username}
  def update_user
    debugger
    unless @current_user.update(user_params)
      render_error_messages(@user)
    else
      @current_user.update(user_params)
      render json: { user: @current_user,
                     profile_image: @current_user.profile_image.attached? ? rails_blob_path(@current_user.profile_image): '',
                     message: "Profile Updated"},
             status: :ok
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  def forgot_password
    @otp_generate = 4.times.map { rand(10) }.join
    @current_user.update(otp: @otp_generate)
    if UserMailer.user_forgot_password(@current_user.email, @otp_generate).deliver_now
      return render json: { message: 'OTP is sent successfully', otp: @otp_generate }, status: :ok
    else
      return render json: { message: 'OTP was not send successfully' }, status: :unprocessable_entity
    end
  end

  def reset_user_password
    if params[:otp].empty?
      return render json: { message: 'OTP not present' }, status: :unprocessable_entity
    end
    if params[:password].empty?
      return render json: { message: 'Password not present' }, status: :unprocessable_entity
    end
    if params[:confirm_password].empty?
      return render json: { message: 'Confirm Password not present' }, status: :unprocessable_entity
    end

    if @current_user.otp == params[:otp]
      if params[:password] == params[:confirm_password]
        @current_user.update(password: params[:password])
        render json: { message: "Password updated" }, status: :ok
      else
        render json: { message: "Passwords don't match" }, status: :not_found
      end
    else
      render json: { message: "Invalid  Otp" }, status: :not_found
    end
  end

  private
  def find_user
    @user = User.find_by_username!(params[:_username])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(:username, :email, :phone, :bio, :password, :password_confirmation, :profile_image
    )
  end
end

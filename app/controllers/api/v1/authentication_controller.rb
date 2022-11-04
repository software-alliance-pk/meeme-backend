class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])

    return render json: { message: "Email not valid" }, status: :not_found unless @user

    if @user&.authenticate(params[:password])
      token = JsonWebTokenService.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      @user.verification_tokens.create(token: token)
      render json: { token: token,
                     expiry: time.strftime("%m-%d-%Y %H:%M"),
                     user: @user,
                     profile_image: @user.profile_image.attached? ? @user.profile_image.blob.url : '',
                     message: "Successfully Logged In" },
             status: :ok
    else
      render json: { message: 'Invalid Password' }, status: :unauthorized
    end
  end

  def logout
    token = request.headers['Authorization']
    verification_token = @current_user.verification_tokens.find_by_token(token)
    if verification_token
      @current_user.verification_tokens.find_by_token(token).destroy
      render json: { message: 'Successfully Signed Out' }, status: :ok
    else
      return render json: { message: 'Verification Token Not Found' }, status: :not_found
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end

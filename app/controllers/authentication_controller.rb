class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebTokenService.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      @user.verification_tokens.create(token: token)
      render json: { token: token,
                     expiry: time.strftime("%m-%d-%Y %H:%M"),
                     user: @user,
                     message: "Successfully Logged In" },
             status: :ok
    else
      render json: { error: 'Enter valid email/password' }, status: :unauthorized
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

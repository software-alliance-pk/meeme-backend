class Api::V1::ApiController < ActionController::API
  def render_error_messages(object)
    render json: {
      message: object.errors.messages.map { |msg, desc|
        msg.to_s.capitalize.to_s.gsub("_"," ") + ' ' + desc[0] }.join(', ')
    }, status: :unprocessable_entity
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    verification_token = VerificationToken.find_by_token(header)
    if verification_token.present?
      begin
        @decoded = JsonWebTokenService.decode(header)
        @current_user = User.find_by_id(@decoded[:user_id]) || User.find_by_email(@decoded[:email])
      if @current_user&.disabled
        verification_token.destroy
        render json: { message: 'Your account has been disabled. Please contact the administrator.' }, status: :forbidden
      else
        @current_user
      end
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: 'Invalid Authentication' }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { message: 'Invalid Authentication' }, status: :unauthorized
      end
    else
      render json: { message: 'User not logged in' }, status: :unauthorized
    end
  end
end
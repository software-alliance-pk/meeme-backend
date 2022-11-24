class SocialLoginService
  require 'net/http'
  PASSWORD_DIGEST = SecureRandom.hex(10)
  APPLE_PEM_URL = 'https://appleid.apple.com/auth/keys'

  def initialize(provider, token, type, fcm_token)
    @token = token
    @provider = provider.downcase
    @type = type
    @fcm_token = fcm_token
  end

  def social_login
    if @provider == 'google'
      google_signup(@token)
    elsif @provider == 'facebook'
      facebook_signup(@token)
    elsif @provider == 'apple'
      apple_signup(@token)
    end
  end

  def google_signup(token)
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'

    json_response = JSON.parse(response.body)
    user = create_user(json_response['email'], json_response['sub'], json_response)

    profile_image=  user.profile_image.attached? ? user.profile_image.blob.url : ''
    token = JsonWebTokenService.encode(user_id: user.id)
    user.verification_tokens.create(token: token,user_id: user.id)
    [user, token, profile_image]
  end

  def facebook_signup(token)
    uri = URI("https://graph.facebook.com/v13.0/me?fields=name,email&access_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'

    json_response = JSON.parse(response.body)
    user = create_user(json_response['email'], json_response['sub'], json_response)

    profile_image=  user.profile_image.attached? ? user.profile_image.blob.url : ''
    token = JsonWebTokenService.encode(user_id: user.id)
    user.verification_tokens.create(token: token,user_id: user.id)

    [user, token, profile_image]
  end

  def apple_signup(token)
    jwt = token
    begin
      header_segment = JSON.parse(Base64.decode64(jwt.split(".").first))
      alg = header_segment["alg"]
      kid = header_segment["kid"]
      apple_response = Net::HTTP.get(URI.parse(APPLE_PEM_URL))
      apple_certificate = JSON.parse(apple_response)
      keyHash = ActiveSupport::HashWithIndifferentAccess.new(apple_certificate["keys"].select { |key| key["kid"] == kid }[0])
      jwk = JWT::JWK.import(keyHash)
      token_data = JWT.decode(jwt, jwk.public_key, true, { algorithm: alg })[0]
    rescue StandardError => e
      return e.as_json
    end

    data = token_data.with_indifferent_access
    token = JsonWebTokenService.encode(user_id: @user.id)
    user = create_user(data['email'], data['sub'], data)
    if @fcm_token.present?
      token = user.mobile_devices.find_or_create_by(mobile_token: @fcm_token)
    end
    [user, token]
  end

  private

  def create_user(email, provider_id, response)
    if (@user = User.find_by(email: email))
      @user
    else
      @user = User.create(email: email, password: PASSWORD_DIGEST, password_confirmation: PASSWORD_DIGEST, username: response['name'])
    end
  end
end
class SocialLoginService
  require 'net/http'
  require 'json'
  PASSWORD_DIGEST = SecureRandom.hex(10)
  APPLE_PEM_URL = 'https://appleid.apple.com/auth/keys'

  def initialize(provider, token, type, mobile_token )
    @token = token
    @provider = provider.downcase
    @type = type
    @fcm_token = mobile_token
  end

  def social_login
    if @provider == 'google'
      google_signup(@token)
    elsif @provider == 'facebook'
      facebook_signup(@token)
    elsif @provider == 'apple'
      apple_signup(@token)
    elsif @provider == 'google_web'
      google_signup_web(@token)
    end
  end

  def google_signup(token)
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'

    json_response = JSON.parse(response.body)
    create_user(json_response['email'], json_response['sub'], json_response)

    profile_image=  @user.profile_image.attached? ? @user.profile_image.blob.url : ''
    token = JsonWebTokenService.encode(user_id: @user.id)
    @user.verification_tokens.create(token: token,user_id: @user.id)
    [@user, token, profile_image]
  end


  def google_signup_web(token)
    puts " Access Token = #{token}"
    uri = URI("https://www.googleapis.com/oauth2/v3/userinfo")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{token}"
  
    begin
      response = http.request(request)
  
      if response.code == '200'
        json_response = JSON.parse(response.body)
        create_user(json_response['email'], json_response['sub'], json_response)
  
        profile_image = @user.profile_image.attached? ? @user.profile_image.blob.url : ''
        token = JsonWebTokenService.encode(user_id: @user.id)
        @user.verification_tokens.create(token: token, user_id: @user.id)
  
        [@user, token, profile_image]
      else
        # Log the error details for debugging
        Rails.logger.error("Google API Error Response: #{response.body}")
  
        error_message = "Failed to authenticate with Google. Error code: #{response.code}"
        raise StandardError, error_message
      end
    rescue StandardError => e
      # Handle the exception (e.g., log the error and return a user-friendly message)
      Rails.logger.error("Error during Google authentication: #{e.message}")
      raise StandardError, "Failed to authenticate with Google. Please try again later."
    end
  end
  


  

  def facebook_signup(token)
    uri = URI("https://graph.facebook.com/v13.0/me?fields=name,email&access_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'

    json_response = JSON.parse(response.body)
    create_user(json_response['email'], json_response['sub'], json_response)

    unless @user.persisted?
      return [@user, nil, ''] 
    end

    profile_image=  @user.profile_image.attached? ? @user.profile_image.blob.url : ''
    token = JsonWebTokenService.encode(user_id: @user.id)
    @user.verification_tokens.create(token: token,user_id: @user.id)

    [@user, token, profile_image]
  end

  def apple_signup(token)
    jwt = token
    begin
      header_segment = JSON.parse(Base64.decode64(jwt.split(".").first))
      alg = header_segment["alg"]
      kid = header_segment["kid"]
      apple_certificate_json = <<~JSON
      {
        "keys": [
        {
          "kty": "RSA",
          "kid": "dMlERBaFdK",
          "use": "sig",
          "alg": "RS256",
          "n": "ryLWkB74N6SJNRVBjKF6xKMfP-QW3AAsJotv0LjVtf7m4NZNg_gTL78e7O8wmvngF8FuzBrvqf1mGW17Ct8BgNK6YXxnoGL0YLmlwXbmCZvTXki0VlEW1PDXeViWy7qXaCp2caF5v4OOdPsgroxNO_DgJRTuA_izJ4DFZYHCHXwojfdWJiDYG67j5PlD5pXKGx7zaqyryjovZTEII_Z1_bhFCRUZRjfJ3TVoK0fZj2z7iAZWjn33i-V3zExUhwzEyeuGph0118NfmOLCUEy_Jd4xvLf_X4laPpe9nq8UeORfs72yz2qH7cHDKL85W6oG08Gu05JWuAs5Ay49WxJrmw",
          "e": "AQAB"
        },
        {
          "kty": "RSA",
          "kid": "rBRfVmqsjn",
          "use": "sig",
          "alg": "RS256",
          "n": "pPOaiF5yL-y42FaKg9PYASR5-rdTK7NEiteNUAzNp0zkta-HW-tgLNLNlsft3zcrsgOLqXxhX7qzlI3JGH-wSs7_v2XNSg57QhOTxPDqtUfy5DegtiSOgwE947OBTwCWo2R6cGZD1T8ysfO2HuKheq2hEwZU4Y-8qT19WWOhZHs4CVt7A5mzpIgWuUVw766VTyqrqKev32DOUPIqFocFz3tuty95S9t_OYnaPCcET-b6DV_eT7psPhqhl5nNUm0lzkCQ53-9kxQNJxBciy0wiBcAexD4KppKRRD3evFpOSxD1R6Kg2DIG5UnbVVqn5nhZA9RH-t50f_biqV3KlSHJQ",
          "e": "AQAB"
        },
        {
          "kty": "RSA",
          "kid": "FftONTxoEg",
          "use": "sig",
          "alg": "RS256",
          "n": "wio-SFzFvKKQ9vl5ctaYSi09o8k3Uh7r6Ht2eJv-hSaZ6A6xTXVIBVSm0KvPxaJlpjYPTCcl2sdEyXlD2Uh1khUKU7r9ON3rpN8pFHAere5ig_JGVEShxmt5E_jzMymYnSfkoSW44ulevQeUwP_MiC5VC1KJjTfD73ghX0tQ0-_RjTJJ2cLyFC4VFNboBMCVioUrz8IA3c0KIOl507qswQvMsh2vBTMDDSJfippAGLzUiWXxUlid-vyOC8GCtag61taSorxCw14irk-tsh7hWjDDkSTFn2gChPMfXXj10_lCv0UG29TVUVCAsay4pszzgmc4zwhgSsqQRd939BJexw",
          "e": "AQAB"
        }
      ]
    }
    JSON

    apple_certificate = JSON.parse(apple_certificate_json)
      # apple_certificate = JSON.parse(apple_response)
      keyHash = ActiveSupport::HashWithIndifferentAccess.new(apple_certificate["keys"].select { |key| key["kid"] == kid }[0])
      jwk = JWT::JWK.import(keyHash)
      token_data = JWT.decode(jwt, jwk.public_key, true, { algorithm: alg })[0]
    rescue StandardError => e
      puts "Rescue Error === #{e}"
      return e.as_json
    end

    data = token_data.with_indifferent_access
    user = create_user(data['email'], data['sub'], data)
    token = JsonWebTokenService.encode(user_id: @user.id)
    @user.verification_tokens.create(token: token,user_id: @user.id)
    [@user, token]
  end
 
  private

  def create_user(email, provider_id, response)
    if (@user = User.find_by(email: email))
      @user
      MobileDevice.find_or_create_by(mobile_token: @fcm_token, user_id: @user.id)
    else
      if response['iss'] == "https://appleid.apple.com"
        @user = User.create(email: email, password: PASSWORD_DIGEST,
          password_confirmation: PASSWORD_DIGEST,
          username: response['email'].split('@').first)
        MobileDevice.find_or_create_by(mobile_token: @fcm_token, user_id: @user.id)
      else
        @user = User.create(email: email, password: PASSWORD_DIGEST,
                            password_confirmation: PASSWORD_DIGEST,
                            username: response['name'])
        MobileDevice.find_or_create_by(mobile_token: @fcm_token, user_id: @user.id)
      end
    end
  end
end
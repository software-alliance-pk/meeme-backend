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
          "kid": "pyaRQpAbnY",
          "use": "sig",
          "alg": "RS256",
          "n": "qHiwOpizi6xHG8FIOSWH4l0P1CjLIC7aBFkhbk7BrD4s9KQAs5Sj5xAtOwlZMyP2XFcqRtZBLIMM7vw_CNERtRrhc68se5hQE_vsrHy7ugcQU6ogJS6s54zqO-zTUfaa3mABM6iR-EfgSpvz33WTQZAPtwAyxaSLknHyDzWjHEZ44WqaQBdcMAvgsWMYG5dBfnV-3Or3V2r1vdbinRE5NomE2nsKDbnJ3yo3u-x9TizKazS1JV3umt71xDqbruZLybIrimrzg_i9OSIzT2o5ZWz8zdYkKHZ4cvRPh-DDt8kV7chzR2tenPF2c5WXuK-FumOrjT7WW6uwSvhnhwNZuw",
          "e": "AQAB"
        },
        {
          "kty": "RSA",
          "kid": "Bh6H7rHVmb",
          "use": "sig",
          "alg": "RS256",
          "n": "2HkIZ7xKMUYH_wtt2Gwq6jXKRl-Ng5vdwd-XcWn5RIW82-uxdmGJyTo3T6MPty-xWUeW7FCs9NlM4yu02GKgwep7TKfnOovP78sd3rESbZsvuN7zD_Vk6aZP7QfqblElUtiMQxh9bu-gZUeMZfa_ndX-P5C4yKtZvXGrSPLLjyAcSmSHNLZnWbZXjeIVsgXWHMr5fwVEAkftHq_4py82xgn2XEK0FK9HmWOCZ47Wcx9fWBnqSi9JTJTUX0lh-kI5TcYfv9UKX2oe3uyOn-A460E_L_4ximlM-lgi3otw26EZfAGY9FFgSZoACjhgw_z5NRbK9dycHRpeLY9GxIyiYw",
          "e": "AQAB"
        },
        {
          "kty": "RSA",
          "kid": "T8tIJ1zSrO",
          "use": "sig",
          "alg": "RS256",
          "n": "teUbLrwScsjVrcFAvSrfben3eQaEca3ESBegGh_wdGuLKw6QgwDxY3fC1_WeSVnkJXx72ddw3j2inoADnTyzuNa_PwDSmvJhOhmzOmoltmtKHteGdaXrqMohO6A85WxVKbN7pzDqwZJNrdY12LOltlI8PHIG-elAbKM2XOHiJaZnLpAVckKy6MQYsEExpPB3plGxWZElqwNZY6SUDVeN-o9qg5FJOFg7T7iTVVEagws4DM6uZNMDQGtqg9V9VqPQkUzC-sYd5eqbB9LqH4iN5F6OB7BmD3g3jCu9zgh3O9V24N43EruBCNrmP0xLP5ZliKqozoAcd1nv71HuVm6mgQ",
          "e": "AQAB"
        },
        {
          "kty": "RSA",
          "kid": "pggnQeNCOU",
          "use": "sig",
          "alg": "RS256",
          "n": "xyWY7ydqTVHRzft5fPZmTuD9Ahk7-_2_IekZGy07Ovhj5IhYyVU8Hq5j0_c9m9tSdJTRdKmNjMURpY4ZJ_9rd3EOQ_WnYHM2cZIQ5y3f_WxeElnv_f2fKDruA-ERaQ6duov-3NAXC3oTWdXuRGRLbbfOVCahTjvnAA8YBRUe3llW7ZvTG14g-fAEQVlMYDxxCsbjtBJiUzKxbH-8KvhIhP9AJtiLDfiK1yzVJ7Qn6HNm5AUsFQKOAgTqxDMJkhi7pyntTyxhpkLYTEndaPRXth_LM3hVmaoFb3P3TsPCbDjSEbKy1wAndfPSzUk6qjyyBYhdXH0sgVpKMBAdggylLQ",
          "e": "AQAB"
        },
        {
          "kty": "RSA",
          "kid": "lVHdOx8ltR",
          "use": "sig",
          "alg": "RS256",
          "n": "nXDu9MPf6dmVtFbDdAaal_0cO9ur2tqrrmCZaAe8TUWHU8AprhJG4DaQoCIa4UsOSCbCYOjPpPGGdE_p0XeP1ew55pBIquNhNtNNEMX0jNYAKcA9WAP1zGSkvH5m39GMFc4SsGiQ_8Szht9cayJX1SJALEgSyDOFLs-ekHnexqsr-KPtlYciwer5jaNcW3B7f9VNp1XCypQloQwSGVismPHwDJowPQ1xOWmhBLCK50NV38ZjobUDSBbCeLYecMtsdL5ZGv-iufddBh3RHszQiD2G-VXoGOs1yE33K4uAto2F2bHVcKOUy0__9qEsXZGf-B5ZOFucUkoN7T2iqu2E2Q",
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
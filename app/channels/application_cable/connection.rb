module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      begin
        if request.params[:token].present?
          @jwt_token = request.params[:token]
          self.current_user = find_verified_user
        else
          self.current_user = find_verified_admin
        end
      rescue
        puts "connection is not created"
      end
    end

    private
    attr_reader :jwt_token
    def find_verified_user
      payload = decode_token
      User.find_by_id(payload["user_id"])
    end

    def find_verified_admin
      if verified_user = env['warden'].user
        verified_user
      else
        render json: reject_unauthorized_connection
      end
    end
    def decode_token
      JsonWebTokenService.decode(jwt_token.to_s)
    end
  end
end

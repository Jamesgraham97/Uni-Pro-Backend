# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.email if current_user
    end

    protected

    def find_verified_user
      token = request.params[:token]
      return reject_unauthorized_connection if token.blank?

      secret_key = Rails.application.credentials.dig(:devise, :jwt_secret_key)
      begin
        decoded_token = JWT.decode(token, secret_key)[0]
        user_id = decoded_token['sub'] # Assuming 'sub' is the user id in the token payload
        if (verified_user = User.find_by(id: user_id))
          verified_user
        else
          reject_unauthorized_connection
        end
      rescue JWT::DecodeError
        reject_unauthorized_connection
      end
    end
  end
end

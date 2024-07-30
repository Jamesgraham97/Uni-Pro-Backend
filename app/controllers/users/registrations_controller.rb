# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :authenticate_scope!, only: [:destroy]
    clear_respond_to

    respond_to :json

    def create
      Rails.logger.debug("Received parameters: #{params.inspect}")

      build_resource(sign_up_params)

      if resource.save
        if resource.active_for_authentication?
          token = JWT.encode({ user_id: resource.id }, 'your_secret_key') # Generate the JWT token
          render json: { user: resource, jwt: token }, status: :created # Include the token in the response
        else
          render json: { message: "Signed up but #{resource.inactive_message}" }, status: :ok
        end
      else
        Rails.logger.debug("Resource errors: #{resource.errors.full_messages.inspect}")
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :display_name)
    end

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: resource, status: :created
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end

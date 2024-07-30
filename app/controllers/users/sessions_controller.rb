# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      Rails.logger.info 'Entering create action in SessionsController'
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      Rails.logger.info "Resource after authentication: #{resource.inspect}"
      token = current_token
      respond_with resource, location: after_sign_in_path_for(resource), token:
    end

    def destroy
      Rails.logger.info 'Entering destroy action in SessionsController'
      super
    end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        Rails.logger.info "Successfully authenticated: #{resource.email}"
        render json: { message: 'Logged in successfully.', user: resource, jwt: current_token }, status: :ok
      else
        Rails.logger.warn "Failed to authenticate: #{resource.errors.full_messages}"
        render json: { message: 'Login failed.', errors: resource.errors.full_messages }, status: :unauthorized
      end
    end

    def respond_to_on_destroy
      if current_user
        log_out_success
      else
        log_out_failure
      end
    end

    def log_out_success
      Rails.logger.info "Successfully logged out: #{current_user.email}"
      render json: { message: 'Logged out successfully.' }, status: :ok
    end

    def log_out_failure
      Rails.logger.warn 'Failed to log out'
      render json: { message: 'Log out failure.' }, status: :unauthorized
    end

    def current_token
      request.env['warden-jwt_auth.token']
    end
  end
end

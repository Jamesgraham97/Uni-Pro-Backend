module Api
  module V1
    class ProfilesController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!

      # Show the current user's profile, including their profile picture URL
      def show
        if current_user.profile_picture.attached?
          blob = current_user.profile_picture.blob
          Rails.logger.info "Profile picture content type: #{blob.content_type}" # Log the profile picture content type
        end
        render json: current_user, methods: :profile_picture_url
      end

      # Update the current user's profile with new data
      def update
        if current_user.update(profile_params)
          if params[:user][:profile_picture].present?
            current_user.profile_picture.attach(params[:user][:profile_picture]) # Attach the new profile picture if provided
          end
          render json: current_user, methods: :profile_picture_url
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Strong parameters to permit only allowed attributes for the profile
      def profile_params
        params.require(:user).permit(:bio, :location, :university, :github, :linkedin)
      end
    end
  end
end

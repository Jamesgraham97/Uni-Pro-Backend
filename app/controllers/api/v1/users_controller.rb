# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def index
        @users = User.all
        render json: @users.as_json(methods: [:profile_picture_url])
      end

      def search
        if params[:query].present?
          @users = User.where('display_name ILIKE ? OR email ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
          render json: @users.as_json(methods: [:profile_picture_url])
        else
          render json: { error: 'Query parameter is missing' }, status: :unprocessable_entity
        end
      end
    end
  end
end

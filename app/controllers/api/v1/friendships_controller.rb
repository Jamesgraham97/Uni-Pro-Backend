# frozen_string_literal: true

module Api
  module V1
    class FriendshipsController < ApplicationController
      before_action :authenticate_user!

      def index
        # Fetch unique friends
        friend_ids = current_user.friendships.where(status: 'accepted').pluck(:friend_id) +
                     current_user.inverse_friendships.where(status: 'accepted').pluck(:user_id)
        friends = User.where(id: friend_ids.uniq)

        render json: friends
      end

      def create
        Rails.logger.info("Received parameters: #{friendship_params.inspect}")
        existing_friendship = current_user.friendships.find_by(friend_id: friendship_params[:friend_id])
        inverse_friendship = current_user.inverse_friendships.find_by(user_id: friendship_params[:friend_id])

        if existing_friendship || inverse_friendship
          render json: { status: 'Friend request already sent or received.' }, status: :unprocessable_entity
        else
          @friendship = current_user.friendships.build(friend_id: friendship_params[:friend_id], status: 'pending')
          if @friendship.save
            Notification.create(user: User.find(friendship_params[:friend_id]),
                                content: "#{current_user.display_name} sent you a friend request.", notification_type: 'friend_request', friend_request: @friendship)
            render json: { status: 'Friend request sent.' }, status: :created
          else
            Rails.logger.error("Error saving friendship: #{@friendship.errors.full_messages}")
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      def update
        @friendship = Friendship.find(params[:id])
        if @friendship.update(status: params[:status])
          if params[:status] == 'accepted'
            unless Friendship.exists?(user_id: @friendship.friend_id, friend_id: @friendship.user_id)
              Friendship.create(user_id: @friendship.friend_id, friend_id: @friendship.user_id, status: 'accepted')
            end
            Notification.create(user: @friendship.user,
                                content: "#{@friendship.friend.display_name} accepted your friend request.", notification_type: 'friend_response', friend_request: @friendship)
          end
          render json: { status: 'Friendship updated.' }
        else
          render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @friendship = Friendship.find(params[:id])
        if @friendship.destroy
          render json: { status: 'Friendship deleted.' }
        else
          render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def status
        friend = User.find(params[:id])
        friendship = current_user.friendships.find_by(friend_id: friend.id) || current_user.inverse_friendships.find_by(user_id: friend.id)

        status = if friendship.nil?
                   'not_friends'
                 elsif friendship.status == 'pending'
                   friendship.user_id == current_user.id ? 'request_sent' : 'request_received'
                 elsif friendship.status == 'accepted'
                   'friends'
                 else
                   'unknown'
                 end

        render json: { status: }
      end

      private

      def friendship_params
        params.require(:friendship).permit(:friend_id)
      end
    end
  end
end

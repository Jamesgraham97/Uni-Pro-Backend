module Api
  module V1
    class NotificationsController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!

      # List all notifications for the current user, ordered by creation date
      def index
        notifications = current_user.notifications.order(created_at: :desc)
        render json: notifications.as_json(include: {
                                             team: { only: %i[id name] },
                                             friend_request: { include: { user: { only: %i[id display_name],
                                                                                  methods: [:profile_picture_url] } } }
                                           })
      end

      # Respond to a friend request
      def respond_to_friend_request
        friendship = Friendship.find(params[:friend_request_id])

        if params[:response] == 'accept'
          # Accept the friend request and create a reciprocal friendship
          friendship.update(status: 'accepted')
          Friendship.create(user_id: friendship.friend_id, friend_id: friendship.user_id, status: 'accepted')
          # Notify the user that their friend request was accepted
          Notification.create(user: friendship.user,
                              content: "#{friendship.friend.display_name} accepted your friend request.", notification_type: 'friend_response', friend_request: friendship)
        elsif params[:response] == 'decline'
          # Decline the friend request by deleting the friendship
          friendship.destroy
        end

        # Mark the notification as read
        notification = current_user.notifications.find(params[:id])
        notification.update(read: true)

        render json: { status: 'Friend request response recorded.' }
      end

      # Respond to a team invite
      def respond_to_team_invite
        notification = current_user.notifications.find(params[:id])
        if params[:response] == 'accept'
          # Accept the team invite by creating a team member record
          TeamMember.create(user_id: current_user.id, team_id: notification.team_id)
          notification.update(read: true)
          render json: { status: 'Team invitation accepted.' }
        elsif params[:response] == 'decline'
          # Decline the team invite by marking the notification as read
          notification.update(read: true)
          render json: { status: 'Team invitation declined.' }
        else
          render json: { status: 'Invalid response.' }, status: :unprocessable_entity
        end
      end

      # Mark a notification as read
      def mark_as_read
        notification = current_user.notifications.find(params[:id])
        notification.update(read: true)
        render json: { status: 'Notification marked as read.' }
      end

      # Create a test notification for the current user
      def test_notification
        Notification.create(user: current_user, content: 'This is a test notification.', notification_type: 'test')
        render json: { status: 'Test notification created.' }
      end
    end
  end
end

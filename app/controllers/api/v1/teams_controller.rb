module Api
  module V1
    class TeamsController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!

      # List all teams the current user belongs to, including team members and their profile pictures
      def index
        teams = current_user.teams.includes(team_members: { user: { profile_picture_attachment: :blob } })
        render json: teams.as_json(
          include: {
            team_members: {
              include: {
                user: {
                  only: [:id, :display_name],
                  methods: [:profile_picture_url]
                }
              }
            }
          }
        )
      end

      # Show details of a specific team
      def show
        @team = Team.find(params[:id])
        render json: @team
      end

      # Create a new team
      def create
        # Extract user_ids from the parameters separately
        user_ids = params[:team].delete(:user_ids) || []
      
        # Log the parameters to see what is being received
        Rails.logger.debug "Received team params: #{params[:team].inspect}"
        Rails.logger.debug "Extracted user IDs: #{user_ids.inspect}"
      
        @team = Team.new(team_params)
        @team.owner_id = current_user.id
      
        if @team.save
          # Add current user to team members
          @team.team_members.create(user: current_user) 
      
          user_ids.each do |user_id|
            next if user_id.to_i == current_user.id # Skip adding the current user again
      
            # Only create a notification, don't add to team members
            Notification.create(user_id: user_id,
                                content: "#{current_user.display_name} has invited you to join the team #{@team.name}.",
                                notification_type: 'team_invite', team_id: @team.id)
          end
          render json: @team, status: :created
        else
          Rails.logger.error(@team.errors.full_messages.join(", "))
          render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Update an existing team
      def update
        @team = Team.find(params[:id])
        if @team.update(team_params)
          render json: @team
        else
          render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Delete a team
      def destroy
        @team = Team.find(params[:id])
        @team.destroy
        head :no_content
      end

      private

      # Strong parameters to permit only allowed attributes for team
      def team_params
        params.require(:team).permit(:name)
      end
    end
  end
end

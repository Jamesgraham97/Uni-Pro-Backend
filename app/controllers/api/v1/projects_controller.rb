module Api
  module V1
    class ProjectsController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!
      # Set project before actions that require it
      before_action :set_project, only: %i[show update destroy]

      # List all projects for a specific team
      def index
        team = Team.find(params[:team_id])
        projects = team.projects
        render json: projects
      end

      # Show details of a specific project
      def show
        render json: @project
      end

      # Create a new project for a specific team
      def create
        @team = Team.find(params[:team_id])
        @project = @team.projects.new(project_params)
        if @project.save
          render json: @project, status: :created
        else
          Rails.logger.error(@project.errors.full_messages.join(', ')) # Log validation errors
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Update an existing project
      def update
        if @project.update(project_params)
          render json: @project
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      # Delete a project
      def destroy
        @project.destroy
        head :no_content
      end

      private

      # Set project based on provided parameters
      def set_project
        @project = Project.find(params[:id])
      end

      # Strong parameters to permit only allowed attributes for project
      def project_params
        params.require(:project).permit(:name, :description, :given_date, :due_date, :grade_weight, :module_id)
      end
    end
  end
end
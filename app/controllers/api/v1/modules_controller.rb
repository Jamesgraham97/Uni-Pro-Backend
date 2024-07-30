module Api
  module V1
    class ModulesController < ApplicationController
      # Ensure user is authenticated before allowing access to controller actions
      before_action :authenticate_user!
      # Set course module before actions that require it
      before_action :set_course_module, only: %i[show update destroy]

      # List all course modules for the current user
      def index
        @course_modules = current_user.course_modules
        render json: @course_modules
      end

      # Show details of a specific course module
      def show
        render json: @course_module
      end

      # Create a new course module
      def create
        @course_module = current_user.course_modules.build(course_module_params)
        if @course_module.save
          render json: @course_module, status: :created
        else
          render json: @course_module.errors, status: :unprocessable_entity
        end
      end

      # Update an existing course module
      def update
        if @course_module.update(course_module_params)
          render json: @course_module
        else
          render json: @course_module.errors, status: :unprocessable_entity
        end
      end

      # Delete an existing course module
      def destroy
        @course_module.destroy
        head :no_content
      end

      private

      # Set course module based on provided parameters
      def set_course_module
        @course_module = current_user.course_modules.find(params[:id])
      end

      # Strong parameters to permit only allowed attributes for course module
      def course_module_params
        params.require(:course_module).permit(:name, :description, :color)
      end
    end
  end
end

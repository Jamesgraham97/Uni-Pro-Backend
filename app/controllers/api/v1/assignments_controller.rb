class Api::V1::AssignmentsController < ApplicationController
  # Ensure user is authenticated before allowing access to controller actions
  before_action :authenticate_user!
  # Set course module before creating an assignment
  before_action :set_course_module, only: [:create]
  # Set assignment before actions that require it
  before_action :set_assignment, only: %i[show update destroy update_status]

  # List all assignments for the current user
  def index
    Rails.logger.debug "Processing request to #{request.path} with headers #{request.headers.to_h}"
    Rails.logger.debug "Current user: #{current_user.inspect}"
    @assignments = current_user.assignments
    Rails.logger.debug "Assignments fetched: #{@assignments.pluck(:id)}"
    render json: @assignments
  rescue => e
    Rails.logger.error "Error processing request: #{e.message}"
    render json: { error: e.message }, status: :internal_server_error
  end

  # Show details of a specific assignment
  def show
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "Assignment fetched: #{@assignment.id}"
    render json: @assignment
  end

  # Create a new assignment within the context of a course module
  def create
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "Params: #{params.inspect}"
    @assignment = @course_module.assignments.build(assignment_params.merge(user: current_user))

    if @assignment.save
      Rails.logger.debug "Assignment created: #{@assignment.id}"
      render json: @assignment, status: :created
    else
      Rails.logger.debug "Assignment creation failed: #{@assignment.errors.full_messages}"
      render json: @assignment.errors, status: :unprocessable_entity
    end
  end

  # Update an existing assignment
  def update
    Rails.logger.debug "Current user: #{current_user.inspect}"
    if @assignment.update(assignment_params)
      Rails.logger.debug "Assignment updated: #{@assignment.id}"
      render json: @assignment
    else
      Rails.logger.debug "Assignment update failed: #{@assignment.errors.full_messages}"
      render json: @assignment.errors, status: :unprocessable_entity
    end
  end

  # Delete an existing assignment
  def destroy
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "Assignment destroyed: #{@assignment.id}"
    @assignment.destroy
    head :no_content
  end

  # Update the status of an assignment
  def update_status
    Rails.logger.debug "Current user: #{current_user.inspect}"
    if @assignment.update(status: params[:status])
      Rails.logger.debug "Assignment status updated: #{@assignment.id}"
      render json: @assignment, status: :ok
    else
      Rails.logger.debug "Assignment status update failed: #{@assignment.errors.full_messages}"
      render json: @assignment.errors, status: :unprocessable_entity
    end
  end

  private

  # Set course module based on provided parameters
  def set_course_module
    @course_module = CourseModule.find_by(id: params[:assignment][:course_module_id])
    Rails.logger.debug "Course module set: #{@course_module.inspect}"
  end

  # Set assignment based on provided parameters
  def set_assignment
    @assignment = Assignment.find_by(id: params[:id])
    Rails.logger.debug "Assignment set: #{@assignment.inspect}"
  end

  # Strong parameters to permit only allowed attributes for assignment
  def assignment_params
    params.require(:assignment).permit(:title, :description, :due_date, :given_date, :status, :priority, :grade_weight, :course_module_id, :user_id)
  end
end

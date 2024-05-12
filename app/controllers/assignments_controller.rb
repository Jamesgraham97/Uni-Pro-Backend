class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  layout 'authenticated'
  before_action :set_course_module, only: [:show, :edit, :update, :destroy, :create, :new]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  def index
    @assignments = Assignment.all
  end

  def show
  end

  def new
    @assignment = @course_module.assignments.build
  end

  def create
    @assignment = @course_module.assignments.build(assignment_params)
    if @assignment.save
      redirect_to course_module_assignment_path(@course_module, @assignment), notice: 'Assignment was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to course_module_assignment_path(@course_module, @assignment), notice: 'Assignment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @assignment.destroy
    redirect_to course_module_assignments_path(@course_module), notice: 'Assignment was successfully destroyed.'
  end

  private

  def set_course_module
    @course_module = CourseModule.find(params[:course_module_id])
  end

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:title, :description, :due_date, :given_date, :status, :priority, :grade_weight)
  end
end

class ModulesController < ApplicationController
  before_action :authenticate_user!
  layout 'authenticated'
  before_action :set_course_module, only: [:show, :edit, :update, :destroy]

  def index
    @course_modules = CourseModule.all
  end

  def show
  end

  def new
    @course_module = CourseModule.new
  end

  def create
    @course_module = CourseModule.new(course_module_params)
    if @course_module.save
      redirect_to @course_module, notice: 'Course module was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course_module.update(course_module_params)
      redirect_to @course_module, notice: 'Course module was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @course_module.destroy
    redirect_to course_modules_path, notice: 'Course module was successfully destroyed.'
  end

  private

  def set_course_module
    @course_module = CourseModule.find(params[:id])
  end

  def course_module_params
    params.require(:course_module).permit(:name, :description)
  end
end

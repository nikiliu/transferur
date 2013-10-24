class CoursesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @title  = "New Course"
    @school = School.find_by(id: params[:school_id])
    @course = @school.courses.new
  end

  def create
    @title  = "New Course"
    @school = School.find_by(id: params[:school_id])
    @course = @school.courses.new(protected_params)
    if @course.save
      flash[:success] = "Course successfully created."
      redirect_to edit_school_path(@school)
    else
      render "new"
    end
  end

  def edit
    @title  = "Edit Course"
    @school = School.find_by(id: params[:school_id])
    @course = @school.courses.find_by(id: params[:id])
  end

  def update
    @title  = "Edit Course"
    @school = School.find_by(id: params[:school_id])
    @course = @school.courses.find_by(id: params[:id])
    if @course.update_attributes(protected_params)
      flash[:success] = "Course successfully updated."
      redirect_to edit_school_path(@school)
    else
      render "edit"
    end
  end

  def destroy
    school = School.find_by(id: params[:school_id])
    course = school.courses.find_by(id: params[:id])
    course.destroy!
    flash[:success] = "Course successfully deleted."
    redirect_to edit_school_path(school)
  end

  private

    def protected_params
      params.require(:course).permit(:name, :course_num)
    end
end

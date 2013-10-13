class StudentPagesController < ApplicationController

  # Handles homepage
  def home
    @transfer_schools = School.where.not(id: 1).order(:name)
    @ur_courses       = School.first.courses.all
  end

  # Returns a label and select corresponding to the given school_id
  def update_transfer_courses
    @transfer_courses = School.find_by(id: params[:school_id]).courses.all
    render partial: "transfer_courses"
  end

  def new_transfer_request
  end
end

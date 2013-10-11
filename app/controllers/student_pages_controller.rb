class StudentPagesController < ApplicationController
  def home
    @transfer_schools = School.where.not(id: 1).order(:name)
    @ur_courses       = School.first.courses.all
  end

  def new_transfer_request
  end
end

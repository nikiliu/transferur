class StudentPagesController < ApplicationController
  def home
    @title            = "Home"
    @transfer_schools = School.all
    @ur_courses       = School.first.courses.all
  end

  def new_transfer_request
  end
end

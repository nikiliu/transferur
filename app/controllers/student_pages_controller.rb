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

  # Check whether a transfer request can be approved
  def new_transfer_request

    # Parse form data
    student_name       = params[:name]
    student_email      = params[:email]
    transfer_school_id = params[:transfer_school]
    transfer_course_id = params[:transfer_course]
    ur_course_id       = params[:course_number]

    # Search database for an existing transfer request based on form data
    query = TransferRequest.find_by(transfer_school_id: transfer_school_id,
                                    transfer_course_id: transfer_course_id,
                                    ur_course_id:       ur_course_id)

    # Display output corresponding to whether the transfer request is approved,
    # not approved, or pending.
    if query != nil
      @pending  = false
      @approved = query.approved
      @reasons  = query.reasons
    else
      @pending = true
    end
  end
end

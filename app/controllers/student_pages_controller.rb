class StudentPagesController < ApplicationController

  # Handles homepage
  def home
    @transfer_schools = School.where.not(id: 1).order(:name)
    @ur_courses       = School.first.courses
  end

  # Returns a label and select corresponding to the given school_id
  def update_transfer_courses
    @transfer_courses = School.find_by(id: params[:school_id]).courses
    render partial: "transfer_courses"
  end

  # Check whether a transfer request can be approved
  def new_transfer_request

    # Parse form data
    student_name       = params[:name]
    student_email      = params[:email]
    transfer_school_id = params[:transfer_school]
    transfer_course_id = params[:transfer_course]
    transfer_online    = params[:online] == "1"            # convert to boolean
    transfer_dual      = params[:dual_enrollment] == "1"   # convert to boolean
    ur_course_id       = params[:course_number]

    # Validate name and email fields
    if student_name.empty?
      flash[:error] = "Please enter your name."
      redirect_to root_path
      return
    elsif student_email.empty? or not student_email =~ /@/
      flash[:error] = "Please enter a valid email address."
      redirect_to root_path
      return
    end

    # Search database for an existing transfer request based on form data
    query = TransferRequest.find_by(transfer_school_id: transfer_school_id,
                                    transfer_course_id: transfer_course_id,
                                    ur_course_id:       ur_course_id)

    # Set up email parameters hash
    transfer_school = School.find_by(id: transfer_school_id)
    transfer_course = transfer_school.courses.find_by(id: transfer_course_id)
    ur_course       = School.first.courses.find_by(id: ur_course_id)
    email_data      = {
      name:                 student_name,
      email:                student_email,
      transfer_school:      transfer_school.name,
      transfer_course_name: transfer_course.name,
      transfer_course_num:  transfer_course.course_num,
      dual_enrollment:      transfer_dual,
      online:               transfer_online,
      ur_course_name:       ur_course.name,
      ur_course_num:        ur_course.course_num,
    }

    # Handle cases for submitted form data. First case: online courses.
    if transfer_online
      flash[:success]       = "Your transfer request for an online course was successfully submitted. " +
                              "Please check your email to see if your request was approved."
      email_data[:approved] = false
      email_data[:reasons]  = "Online courses not accepted."
      ResultsMailer.result_email(email_data).deliver

    # TransferRequest reviewed within 5 years exists
    elsif query != nil and query.updated_at >= 5.years.ago and not transfer_dual
      flash[:success]       = "Your transfer request was successfully submitted. Please check " +
                              "your email to see if your request was approved."
      email_data[:approved] = query.approved
      email_data[:reasons]  = query.reasons
      ResultsMailer.result_email(email_data).deliver

    # Transfer course is dual enrollment, or corresponding TransferRequest does not exist
    else
      flash[:pending] = "Your transfer request is currently pending. An email notification " +
                        "will be sent once your request is approved or not approved."
    end

    # Redirect back to main form
    redirect_to root_path
  end
end

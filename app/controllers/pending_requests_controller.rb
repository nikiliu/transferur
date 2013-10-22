class PendingRequestsController < ApplicationController
  before_filter :authenticate_user!,  only: [:show, :edit, :update, :destroy]
  before_filter :schools_and_courses, only: [:new, :create]

  def new
    @request = PendingRequest.new
  end

  def create
    @request        = PendingRequest.new(protected_params)
    success_message = "Your transfer request was successfully submitted. Please check " +
                      "your email to see if your request was approved."
    pending_message = "Your transfer request is currently pending. An email notification " +
                      "will be sent once your request is approved or not approved."

    # Validate form input
    if @request.valid?

      # Generate email parameters hash
      email_params = generate_email_hash(params)

      # Cannot approve online course requests
      if checkbox_boolean(params, :online)
        flash[:success]         = success_message
        email_params[:approved] = false
        email_params[:reasons]  = "Online courses not accepted."
        ResultsMailer.result_email(email_params).deliver
        redirect_to root_path
        return
      end

      # TransferRequest object found in database, it was updated within 5 years, and this
      # is not a dual enrollment request.
      query = TransferRequest.find_by(query_params)
      if !query.nil? and query.updated_at >= 5.years.ago and not checkbox_boolean(params, :dual_enrollment)
        flash[:success]         = success_message
        email_params[:approved] = query.approved
        email_params[:reasons]  = query.reasons
        ResultsMailer.result_email(email_params).deliver

      # Create new PendingRequest
      else
        # @request.save
        flash[:pending] = pending_message
      end

      # Redirect back to form
      redirect_to root_path

    # Invalid form input, display errors
    else
      render "new"
    end
  end

  # Generates option tags for other transfer course section given a school id via GET request
  def update_transfer_courses
    @transfer_courses = School.find_by(id: params[:school_id]).courses
    render partial: "transfer_courses_options"
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def protected_params
      params.require(:pending_request).permit(
        :requester_name,
        :requester_email,
        :transfer_school_id,
        :transfer_school_other,
        :transfer_school_name,
        :transfer_school_location,
        :transfer_school_international,
        :transfer_course_id,
        :transfer_course_other,
        :transfer_course_name,
        :transfer_course_num,
        :transfer_course_url,
        :ur_course_id
      )
    end

    def query_params
      params.require(:pending_request).permit(
        :transfer_school_id,
        :transfer_course_id,
        :ur_course_id
      )
    end

    # Returns email parameters hash given the params from "create"
    def generate_email_hash(params)
      transfer_school = School.find_by(id: param_val(params, :transfer_school_id))
      transfer_course = transfer_school.courses.find_by(id: param_val(params, :transfer_course_id))
      ur_course       = School.first.courses.find_by(id: param_val(params, :ur_course_id))
      {
        name:                 param_val(params, :requester_name),
        email:                param_val(params, :requester_email),
        transfer_school:      transfer_school.name,
        transfer_course_name: transfer_course.name,
        transfer_course_num:  transfer_course.course_num,
        ur_course_name:       ur_course.name,
        ur_course_num:        ur_course.course_num,
        dual_enrollment:      checkbox_boolean(params, :dual_enrollment),
        online:               checkbox_boolean(params, :online),
      }
    end

    # Gets value of given key in params hash
    def param_val(params, key)
      params[:pending_request][key]
    end

    # Returns true if the passed checkbox value in params was checked
    def checkbox_boolean(params, checkbox_val)
      params[checkbox_val] == "1"
    end

    # Sets instance variables for "new" and "create"
    def schools_and_courses
      @transfer_schools = School.where.not(id: 1).order(:name)
      @ur_courses       = School.first.courses
    end
end

class PendingRequestsController < ApplicationController
  before_filter :schools_and_courses, only: [:new, :create]
  before_filter :authenticate_user!,  only: [:index, :edit, :update, :destroy]
  before_filter :set_body_class

  def new
    @body_class = "live"
    @request    = PendingRequest.new
  end

  def create
    @body_class     = "live"
    @request        = PendingRequest.new(protected_params)
    success_message = "Your transfer request was successfully submitted. Please check " +
                      "your email to see if your request was approved."
    pending_message = "Your transfer request is currently pending. An email notification " +
                      "will be sent once your request is approved or not approved."

    # Validate form input
    if @request.valid?
      if params[:online] == "1"
        #----------------------------------------------------------------
        # Case 1. Cannot approve online course requests
        #----------------------------------------------------------------
        flash[:success] = success_message
        ResultsMailer.result_email(params, {
          approved: false,
          reasons:  "Online courses not accepted."
        }).deliver
      else
        query = TransferRequest.find_by(query_params)
        if !query.nil? and query.updated_at >= 5.years.ago and
           params[:pending_request][:dual_enrollment] != "1" and
           params[:pending_request][:transfer_school_other] != "1" and
           params[:pending_request][:transfer_course_other] != "1"
          #--------------------------------------------------------------
          # Case 2. Valid transfer request exists
          #--------------------------------------------------------------
          flash[:success] = success_message
          ResultsMailer.result_email(params, {
            approved: query.approved,
            reasons:  query.reasons
          }).deliver
        else
          #--------------------------------------------------------------
          # Case 3. Create new pending request
          #--------------------------------------------------------------
          @request.save
          flash[:pending] = pending_message
          AdminMailer.pending_request_notification.deliver
        end
      end
      redirect_to root_path
    else
      #------------------------------------------------------------------
      # Case 4. Invalid form input
      #------------------------------------------------------------------
      render "new"
    end
  end

  # Generates option tags for other transfer course section given a school id via GET request
  def update_transfer_courses
    @transfer_courses = School.find_by(id: params[:school_id]).courses
    render partial: "transfer_courses_options"
  end

  #----------------------------------------------------------------------
  # START ADMIN ACTIONS
  #----------------------------------------------------------------------

  def index
    @title    = "Pending Requests"
    @requests = PendingRequest.all
  end

  def edit
    @request = PendingRequest.find_by(id: params[:id])
  end

  def update
    @request = PendingRequest.find_by(id: params[:id])

    #--------------------------------------------------------------------
    # Step 0. Set up hashes used to search for existing schools/courses
    #--------------------------------------------------------------------
    school_params = {
      name:          @request.transfer_school_name,
      location:      @request.transfer_school_location,
      international: @request.transfer_school_international
    }
    course_params = {
      name:          @request.transfer_course_name,
      course_num:    @request.transfer_course_num
    }

    #--------------------------------------------------------------------
    # Step 1. Ensure transfer school in database (create if not)
    #--------------------------------------------------------------------
    transfer_school = nil
    if @request.transfer_school_other
      transfer_school = School.find_by(school_params)
      if transfer_school.nil?
        transfer_school = School.create!(school_params)
      end
    else
      # Not other transfer school, look up existing school
      transfer_school = School.find_by(id: @request.transfer_school_id)
    end

    #--------------------------------------------------------------------
    # Step 2. Ensure transfer course in database (create if not)
    #--------------------------------------------------------------------
    transfer_course = nil
    if @request.transfer_course_other
      transfer_course = transfer_school.courses.find_by(course_params)
      if transfer_course.nil?
        transfer_course = transfer_school.courses.create!(course_params)
      end
    else
      # Not other transfer course, look up existing course
      transfer_course = transfer_school.courses.find_by(id: @request.transfer_course_id)
    end

    #--------------------------------------------------------------------
    # Step 3. Create new transfer request
    #--------------------------------------------------------------------
    TransferRequest.create!(transfer_school_id: transfer_school.id,
                            transfer_course_id: transfer_course.id,
                            ur_course_id:       @request.ur_course_id,
                            approved: true)

    #--------------------------------------------------------------------
    # Step 4. Send notification email to requester
    #--------------------------------------------------------------------
    email_params = { pending_request: {} }
    attr_to_hash(@request, email_params[:pending_request])
    ResultsMailer.result_email(email_params, {
      approved: true,
      reasons:  ""
    }).deliver

    @request.destroy!
    flash[:success] = "Pending request approved."
    redirect_to pending_requests_path
  end

  def destroy
    @request = PendingRequest.find_by(id: params[:id])

    email_params = { pending_request: {} }
    attr_to_hash(@request, email_params[:pending_request])
    ResultsMailer.result_email(email_params, {
      approved: false,
      reasons:  params[:reasons]
    }).deliver

    @request.destroy!
    flash[:success] = "Pending request disapproved."
    redirect_to pending_requests_path
  end

  #----------------------------------------------------------------------
  # END ADMIN ACTIONS
  #----------------------------------------------------------------------

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
        :dual_enrollment,
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

    # Sets instance variables for "new" and "create"
    def schools_and_courses
      @transfer_schools = School.where.not(id: 1).order(:name)
      @ur_courses       = School.first.courses
    end

    # Creates key/value pairs out of given object's attributes
    def attr_to_hash(obj, hash)
      obj.attribute_names.each do |attr|
        hash[attr.to_sym] = obj.read_attribute(attr)
      end
    end

    def set_body_class
      @body_class = "requests"
    end
end

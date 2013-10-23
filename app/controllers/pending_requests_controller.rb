class PendingRequestsController < ApplicationController
  before_filter :schools_and_courses, only: [:new, :create]
  before_filter :authenticate_user!,  only: [:index, :edit, :update, :destroy]

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
      if params[:online] == "1"
        # Cannot approve online course requests
        flash[:success] = success_message
        ResultsMailer.result_email(params, {
          approved: false,
          reasons:  "Online courses not accepted."
        }).deliver
      else
        query = TransferRequest.find_by(query_params)
        if !query.nil? and query.updated_at >= 5.years.ago and params[:dual_enrollment] != "1"
          # TransferRequest object found in database, it was updated within 5 years, and this
          # is not a dual enrollment request.
          flash[:success] = success_message
          ResultsMailer.result_email(params, {
            approved: query.approved,
            reasons:  query.reasons
          }).deliver
        else
          # Create new PendingRequest
          # @request.save
          flash[:pending] = pending_message
          AdminMailer.pending_request_notification.deliver
        end
      end
      redirect_to root_path
    else
      # Invalid form input, display errors
      render "new"
    end
  end

  # Generates option tags for other transfer course section given a school id via GET request
  def update_transfer_courses
    @transfer_courses = School.find_by(id: params[:school_id]).courses
    render partial: "transfer_courses_options"
  end

  def index
    @title    = "Pending Requests"
    @requests = PendingRequest.all
  end

  def edit
    @request = PendingRequest.find_by(id: params[:id])
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

    # Sets instance variables for "new" and "create"
    def schools_and_courses
      @transfer_schools = School.where.not(id: 1).order(:name)
      @ur_courses       = School.first.courses
    end
end

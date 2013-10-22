class PendingRequestsController < ApplicationController
  before_filter :authenticate_user!,  only: [:show, :edit, :update, :destroy]
  before_filter :schools_and_courses, only: [:new, :create]

  def new
    @request = PendingRequest.new
  end

  def create
    @request = PendingRequest.new(protected_params)
    if @request.valid?
      flash[:pending] = "Your transfer request is currently pending. An email notification " +
                        "will be sent once your request is approved or not approved."
      redirect_to root_path
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

    def schools_and_courses
      @transfer_schools = School.where.not(id: 1).order(:name)
      @ur_courses       = School.first.courses
    end
end

class PendingRequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @transfer_schools = School.where.not(id: 1).order(:name)
    @ur_courses       = School.first.courses
    @request          = PendingRequest.new
  end

  def create
    @transfer_schools = School.where.not(id: 1).order(:name)
    @ur_courses       = School.first.courses
    @request          = PendingRequest.new(protected_params)
    if @request.save
      flash[:pending] = "Your transfer request is currently pending. An email notification " +
                        "will be sent once your request is approved or not approved."
      redirect_to root_path
    else
      render "new"
    end
  end

  # Generates an other transfer course section given a school id via GET request
  def update_transfer_courses
    @transfer_courses = School.find_by(id: params[:school_id]).courses
    render partial: "transfer_courses"
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
      params.require(:request).permit(
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
end

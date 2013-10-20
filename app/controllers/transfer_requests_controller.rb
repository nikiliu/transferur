class TransferRequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @request         = TransferRequest.new
    @ur_courses      = School.first.courses
    @transfer_school = School.find_by(id: params[:transfer_school_id])
    @transfer_course = @transfer_school.courses.find_by(id: params[:transfer_course_id])
  end

  def create
    @request = TransferRequest.new(protected_params)
    if @request.save
      flash[:success] = "Transfer request successfully created."
      redirect_to edit_course_path(@request.transfer_school, @request.transfer_course)
    else
      @ur_courses      = School.first.courses
      @transfer_school = School.find_by(id: params[:transfer_request][:transfer_school_id])
      @transfer_course = @transfer_school.courses.find_by(id: params[:transfer_request][:transfer_course_id])
      render "new"
    end
  end

  def edit
    @request = TransferRequest.find_by(id: params[:id])
  end

  def update
    @request = TransferRequest.find_by(id: params[:id])
    if @request.update_attributes(protected_params)
      flash[:success] = "Transfer request successfully updated."
      redirect_to edit_transfer_request_path(@request)
    else
      render "edit"
    end
  end

  def destroy
    @request        = TransferRequest.find_by(id: params[:id])
    transfer_school = @request.transfer_school
    transfer_course = @request.transfer_course
    @request.destroy!
    flash[:success] = "Transfer request successfully deleted."
    redirect_to edit_course_path(transfer_school, transfer_course)
  end

  private

    def protected_params
      params.require(:transfer_request).permit(:transfer_school_id,
                                               :transfer_course_id,
                                               :ur_course_id,
                                               :approved,
                                               :reasons)
    end
end

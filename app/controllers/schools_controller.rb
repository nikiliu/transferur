class SchoolsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_body_class

  def index
    @title   = "Schools & Courses"
    @schools = School.all.order(:name)
  end

  def new
    @title  = "New School"
    @school = School.new
  end

  def create
    @title  = "New School"
    @school = School.new(protected_params)
    if @school.save
      flash[:success] = "School successfully created."
      redirect_to edit_school_path(@school)
    else
      render "new"
    end
  end

  def edit
    @title  = "Edit School"
    @school = School.find_by(id: params[:id])
  end

  def update
    @title  = "Edit School"
    @school = School.find_by(id: params[:id])
    if @school.update_attributes(protected_params)
      flash[:success] = "School successfully updated."
      redirect_to edit_school_path(@school)
    else
      render "edit"
    end
  end

  def destroy
    school = School.find_by(id: params[:id])

    # Delete all requests that had this transfer school
    requests = TransferRequest.where(transfer_school_id: school.id)
    requests.each do |request|
      request.destroy!
    end

    school.destroy!
    flash[:success] = "School successfully deleted."
    redirect_to schools_path
  end

  private

    def protected_params
      params.require(:school).permit(:name, :location, :international)
    end

    def set_body_class
      @body_class = "schools"
    end
end

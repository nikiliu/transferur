class SchoolsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @schools = School.all.order(:name)
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(protected_params)
    if @school.save
      flash[:success] = "School successfully created."
      redirect_to edit_school_path(@school)
    else
      render "new"
    end
  end

  def edit
    @school = School.find_by(id: params[:id])
  end

  def update
    @school = School.find_by(id: params[:id])
    if @school.update_attributes(protected_params)
      flash[:success] = "School successfully updated."
      redirect_to edit_school_path(@school)
    else
      render "edit"
    end
  end

  def destroy
    @school = School.find_by(id: params[:id])
    @school.destroy!
    flash[:success] = "School successfully deleted."
    redirect_to schools_path
  end

  private

    def protected_params
      params.require(:school).permit(:name, :location, :international)
    end
end

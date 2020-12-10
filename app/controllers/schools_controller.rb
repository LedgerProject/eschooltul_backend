class SchoolsController < ApplicationController
  before_action :check_is_administration

  def index
    @schools = School.all
  end

  def show
    @school = find_school
  end

  def new
    @school = School.new
  end

  def edit
    @school = find_school
  end

  def create
    @school = School.new(school_params)

    if @school.save
      redirect_to @school, notice: "School was successfully created."
    else
      render :new
    end
  end

  def update
    @school = find_school

    if @school.update(school_params)
      redirect_to @school, notice: "School was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @school.destroy!

    redirect_to schools_url, notice: "School was successfully destroyed."
  end

  private

  def check_is_administration
    head(:forbidden) unless current_user.administrator?
  end

  def find_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :email, :address, :city)
  end
end

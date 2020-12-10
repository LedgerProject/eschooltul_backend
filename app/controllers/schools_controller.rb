class SchoolsController < ApplicationController
  before_action :check_is_director

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
      redirect_to school_path, notice: "School was successfully created."
    else
      render :new
    end
  end

  def update
    @school = find_school

    if @school.update(school_params)
      redirect_to school_path, notice: "School was successfully updated."
    else
      render :edit
    end
  end

  private

  def check_is_director
    head(:forbidden) unless current_user.director?
  end

  def find_school
    @school = School.first!
  end

  def school_params
    params.require(:school).permit(:name, :email, :address, :city, :logo)
  end
end

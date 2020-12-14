class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = find_course
  end

  def new
    @course = Course.new
  end

  def edit
    @course = find_course
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: "Course was successfully created."
    else
      render :new
    end
  end

  def update
    @course = find_course

    if @course.update(course_params)
      redirect_to @course, notice: "Course was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @course = find_course
    @course.destroy
    redirect_to courses_url, notice: "Course was successfully destroyed."
  end

  private

  def find_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :subject, :user_id)
  end
end

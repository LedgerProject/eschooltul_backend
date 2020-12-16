class CoursesController < AuthenticatedController
  before_action :check_permission

  def index
    @courses = Course.order(:name).page(params[:page])
    @students = Student.all
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
      redirect_to courses_url, notice: "Course was successfully created."
    else
      render :new
    end
  end

  def duplicate
    @course = find_course

    duplicated_course = @course.deep_clone(include: :students)
    duplicated_course.subject += " (Duplicate)"
    duplicated_course.save!

    redirect_to courses_url, notice: "Course was successfully duplicated."
  end

  def update
    @course = find_course

    if @course.update(course_params)
      redirect_to courses_url, notice: "Course was successfully updated."
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
    params.require(:course).permit(:name, :subject, :user_id, student_ids: [])
  end
end

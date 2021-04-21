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
      redirect_to courses_url,
                  notice: t("flash.actions.create.notice", resource_name: t("course.course"))
    else
      render :new
    end
  end

  def duplicate
    @course = find_course

    duplicated_course = @course.deep_clone(include: :students)
    duplicated_course.subject += " (Duplicate)"
    duplicated_course.save!

    redirect_to courses_url,
                notice: t("flash.actions.duplicate.notice", resource_name: t("course.course"))
  end

  def discard
    @course = find_course

    @course.discard
    @course.save!

    redirect_to courses_url,
                notice: t("flash.actions.discard.notice", resource_name: t("course.course"))
  end

  def undiscard
    @course = find_discard_course

    @course.undiscard
    @course.save!

    redirect_to discard_courses_path,
                notice: t("flash.actions.undiscard.notice", resource_name: t("course.course"))
  end

  def update
    @course = find_course

    if @course.update(course_params)
      redirect_to courses_url,
                  notice: t("flash.actions.update.notice", resource_name: t("course.course"))
    else
      render :edit
    end
  end

  def destroy
    @course = find_course
    @course.destroy
    redirect_to courses_url,
                notice: t("flash.actions.destroy.notice", resource_name: t("course.course"))
  end

  private

  def find_course
    @course = Course.find(params[:id])
  end

  def find_discard_course
    Course.with_discarded.discarded.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :subject, :user_id, student_ids: [])
  end
end

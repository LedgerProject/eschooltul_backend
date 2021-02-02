class GradesController < AuthenticatedController
  def index
    @courses = find_courses
  end

  def save
    marks = JSON.parse(params[:marks])
    grades = Grade.new
    grades.save_grades(marks)

    head :ok
  end

  def find_course
    Course.find(params[:course_id])
  end

  def check_permission_on_this_course
    redirect_to grades_courses_path if current_user.course?(params[:course_id])
  end

  private

  def find_courses
    return Course.teacher_grades if current_user.teacher?

    Course.grades
  end
end

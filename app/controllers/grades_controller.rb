class GradesController < AuthenticatedController
  def index
    @courses = find_courses
  end

  def create
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
    return teacher_grades if current_user.teacher?

    all_grades
  end

  def teacher_grades
    Course.where(user_id: current_user.id)
          .includes(:terms, :students, :lessons)
          .map  do |course|
      course.as_json.merge({
                             terms: course.terms.as_json,
                             students: with_marks(course.students),
                             lessons: course.lessons.as_json
                           })
    end
  end

  def all_grades
    Course.includes(:terms, :students, :lessons)
          .map do |course|
      course.as_json.merge({
                             terms: course.terms.as_json,
                             students: with_marks(course.students),
                             lessons: course.lessons.as_json
                           })
    end
  end

  def with_marks(students)
    students.includes(:marks)
            .map do |student|
      student.as_json.merge({ marks: student.marks.as_json })
    end
  end
end

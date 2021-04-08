module Grades
  class CoursesController < GradesController
    def index
      @courses = find_courses
    end

    def show
      @course = find_course
    end

    def save
      marks = JSON.parse(params[:marks])
      grades = Grade.new
      grades.save_grades(marks)

      head :ok
    end

    private

    def find_courses
      return current_user.courses.order(:name).page(params[:page]) if current_user.teacher?

      Course.order(:name).page(params[:page])
    end

    def find_course
      course = Course.find(params[:id])
      course.as_json.merge({
                             terms: course.terms.as_json,
                             students: with_marks(course.students),
                             lessons: course.lessons.as_json
                           })
    end

    def with_marks(students)
      students.includes(:marks)
              .map do |student|
        student.as_json.merge({ marks: student.marks.as_json })
      end
    end
  end
end

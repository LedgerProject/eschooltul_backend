module Grades
  class CoursesController < GradesController
    def index
      @courses = find_courses
    end

    def show
      @course = find_course
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
                             students: with_marks_and_reports(course, course.students),
                             lessons: course.lessons.as_json
                           })
    end

    def with_marks_and_reports(course, students)
      students.includes(:marks, :reports)
              .map do |student|
        student.as_json.merge({
                                marks: student.marks.as_json,
                                reports: student.reports.where(course_id: course.id)
                                .order(date: :desc).select(
                                  :id, :transaction_id, :student_id, :course_id, :content_hash
                                ).as_json
                              })
      end
    end
  end
end

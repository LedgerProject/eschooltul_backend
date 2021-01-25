module Grades
  class CoursesController < GradesController
    def index
      @courses = find_courses
    end

    private

    def find_courses
      return current_user.courses.order(:name).page(params[:page]) if current_user.teacher?

      Course.order(:name).page(params[:page])
    end
  end
end

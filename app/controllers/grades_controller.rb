class GradesController < AuthenticatedController
  def find_course
    Course.find(params[:course_id])
  end
end

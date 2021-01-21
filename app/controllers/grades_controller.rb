class GradesController < AuthenticatedController
  def find_course
    Course.find(params[:course_id])
  end

  def check_permission_on_this_course
    redirect_to grades_courses_path if current_user.course?(params[:course_id])
  end
end

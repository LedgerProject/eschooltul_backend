class DiscardCoursesController < AuthenticatedController
  def index
    @discarded_courses = Course.with_discarded.discarded.order(:name).page(params[:page])
  end
end

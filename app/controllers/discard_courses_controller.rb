class DiscardCoursesController < AuthenticatedController
  def index
    @courses = Course.with_discarded.discarded.order(:name).page(params[:page])
  end
end

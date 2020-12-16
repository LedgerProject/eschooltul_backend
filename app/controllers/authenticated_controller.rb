class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  helper_method :current_school
  helper_method :school_courses

  layout "authenticated"

  def current_school
    School.first
  end

  def school_courses
    if current_user.teacher?
      current_user.courses
    else
      Course.all
    end
  end

  def check_permission
    return redirect_to root_path unless current_user.director? || current_user.administrator?
  end
end

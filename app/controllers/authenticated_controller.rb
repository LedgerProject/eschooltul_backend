class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  helper_method :current_school

  layout "authenticated"

  def current_school
    School.first
  end

  def check_permission
    return redirect_to root_path unless current_user.director? || current_user.administrator?
  end
end

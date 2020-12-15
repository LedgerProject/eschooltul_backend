class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  helper_method :current_school

  layout "authenticated"

  def current_school
    School.first
  end
end

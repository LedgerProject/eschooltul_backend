class AccountsController < AuthenticatedController
  before_action :redirect_unless_director

  def index; end

  private

  def redirect_unless_director
    redirect_to root_path unless current_user.director?
  end
end

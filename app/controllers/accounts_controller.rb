class AccountsController < AuthenticatedController
  before_action :redirect_unless_director

  def index
    @scope = set_scope
    @search = @scope.ransack(params[:q])
    @users = @search.result(distinct: true).order(:name).page(params[:page])
  end

  private

  def redirect_unless_director
    redirect_to root_path unless current_user.director?
  end

  def set_scope
    if params[:role].nil?
      User.all
    else
      User.with_role(params[:role])
    end
  end
end

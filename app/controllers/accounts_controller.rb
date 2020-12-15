class AccountsController < AuthenticatedController
  before_action :redirect_unless_director

  def index
    @scope = set_scope
    @search = @scope.ransack(params[:q])
    @users = @search.result(distinct: true).order(:name).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.add_role role
      redirect_to accounts_path, notice: "Account was successfully created."
    else
      render :new
    end
  end

  def destroy
    @user = find_user
    @user.destroy
    redirect_to accounts_path, notice: "Account was successfully destroyed."
  end

  private

  def redirect_unless_director
    redirect_to root_path unless current_user.director?
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirm,
      :name,
      :first_surname,
      :second_surname
    )
  end

  def find_user
    User.find(params[:id])
  end

  def role
    Role.find(params[:user][:role_ids]).name
  end

  def set_scope
    if params[:role].nil?
      User.all
    else
      User.with_role(params[:role])
    end
  end
end

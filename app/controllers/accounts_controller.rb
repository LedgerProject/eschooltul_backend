class AccountsController < AuthenticatedController
  before_action :redirect_unless_director, except: %i[edit update]

  def index
    @search = User.ransack(params[:q])
    @users = @search.result(distinct: true).order(:name).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.add_role role
      redirect_to accounts_path,
                  notice: t("flash.actions.create.notice", resource_name: t(:account))
    else
      render :new
    end
  end

  def edit; end

  def update
    if current_user.update(update_params)
      redirect_to root_path, notice: t("flash.actions.update.notice", resource_name: t(:profile))
    else
      render :edit
    end
  end

  def destroy
    @user = find_user

    if @user.destroy
      redirect_to accounts_path,
                  notice: t("flash.actions.destroy.notice", resource_name: t(:account))
    else
      redirect_to accounts_path, alert: t("flash.actions.destroy.alert", resource_name: t(:account))
    end
  end

  private

  def redirect_unless_director
    redirect_to root_path unless current_user.director?
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :first_surname,
      :second_surname
    )
  end

  def update_params
    params.require(:user).permit(
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
end

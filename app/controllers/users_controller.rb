class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy correct_user)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def edit; end

  def update
    @user.gender = params[:user][:gender].to_i
    if @user.update_attributes user_params
      flash[:success] = t :profile_updated
      redirect_to @user
    else
      render :edit
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.gender = params[:user][:gender].to_i
    if @user.save
      log_in @user
      flash[:success] = t :welcome
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    if @user.delete
      flash[:success] = t :success_delete_user
      redirect_to users_path
    else
      flash[:danger] = t :unsuccess_delete_user
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :date_of_birth,
      :password, :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "layouts.messages.not_found"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t :please_login
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless @user == current_user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end

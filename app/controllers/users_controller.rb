class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show; end

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
end

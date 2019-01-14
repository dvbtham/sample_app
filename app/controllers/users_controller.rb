class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy
    correct_user following followers)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.activated
    @users = if params[:search].present?
               @users.search_by params[:search][:query]
             else
               @users
             end.paginate(page: params[:page],
    per_page: Settings.per_page.users)
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page],
      per_page: Settings.per_page.microposts)
  end

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
      @user.send_activation_email
      flash[:info] = t :check_mail_msg
      redirect_to root_path
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

  def following
    @title = t "following", count: @user.following.count
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t "follower", count: @user.followers.count
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
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

  def correct_user
    redirect_to root_path unless @user == current_user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end

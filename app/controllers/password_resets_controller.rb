class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t :password_reset_email_sent
      redirect_to root_path
    else
      flash.now[:danger] = t "not_found.email"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(:pass_not_empty)
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t :reset_complete
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash.now[:danger] = t "not_found.email"
    redirect_to new_password_reset_path
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    flash[:warning] = t :invalid_request
    redirect_to root_path
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t :expired
    redirect_to new_password_reset_path
  end
end

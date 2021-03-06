class SessionsController < ApplicationController
  before_action :load_user_by_mail, only: :create

  def new; end

  def create
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        activated @user
      else
        flash[:warning] = t :not_activated
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "layouts.messages.login_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def activated user
    log_in user
    if params[:session][:remember_me] == Settings.remember_me.checked
      remember user
    else
      forget user
    end
    redirect_back_or user
  end

  def load_user_by_mail
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:danger] = t "layouts.messages.not_found"
  end
end

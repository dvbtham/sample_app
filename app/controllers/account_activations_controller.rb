class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if shoud_edit? user
      user.activate
      log_in user
      flash[:success] = t :account_activated
      redirect_to user
    else
      flash[:danger] = t :invalid_activation_link
      redirect_to root_path
    end
  end

  private

  def shoud_edit? user
    user && !user.activated? && user.authenticated?(:activation, params[:id])
  end
end

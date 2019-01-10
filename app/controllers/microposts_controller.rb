class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "microposts.created"
      redirect_to root_path
    else
      @feed_items = Array.new
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.deleted"
      redirect_back fallback_location: root_path
    else
      flash[:danger] = t "microposts.cant_deleted"
      redirect_to root_path
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost
    flash[:danger] = t "layouts.messages.not_found"
    redirect_to root_path
  end
end

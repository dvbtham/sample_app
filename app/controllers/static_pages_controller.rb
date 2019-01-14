class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.feed(current_user.following_ids << current_user.id)
                           .recent_posts
                           .paginate(page: params[:page],
                             per_page: Settings.per_page.microposts)
  end

  def about; end

  def contact; end

  def help; end
end

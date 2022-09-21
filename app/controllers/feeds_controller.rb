class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    authorize @user
    @feed_posts = current_user.generate_posts
    @feed_posts = Array(@feed_posts)
    @suggestions = current_user.suggestions
    @users_with_stories = current_user.generate_stories
  end
end

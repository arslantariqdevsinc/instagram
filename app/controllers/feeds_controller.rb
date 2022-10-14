class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize current_user
    @feed_posts = current_user.generate_posts
    @suggestions = [] # { }User.suggestions(current_user.id).first(5)

    @users_with_stories = current_user.generate_stories
  end
end

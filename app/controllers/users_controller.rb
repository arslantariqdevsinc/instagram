class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, only: %i[following followers feed]

  def index
    @users = User.all
  end

  def show
    @allowed = if current_user
                 this_user? || @user.public? || @user.private? && current_user.following?(@user)
               else
                 @user.public?
               end
    @posts = @user.posts.all if @allowed
  end

  def following
    @title = 'Following'
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers
    render 'show_follow'
  end

  def stories
    @stories = @user.stories.all
  end

  def feed
    @user = current_user
    @feed_posts = @user.generate_posts
    @feed_posts = Array(@feed_posts)
    @suggestions = @user.suggestions
    @users_with_stories = @user.generate_stories
  end

  private

  def set_user
    return unless params.key?(:id)

    @user = User.find_by(username: params[:id])
    redirect_to user_session_path if @user.nil?
  end

  def this_user?
    current_user == @user
  end
end

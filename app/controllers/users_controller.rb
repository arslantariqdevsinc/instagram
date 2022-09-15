class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, only: %i[following followers feed]

  def index
    @users = User.all
  end

  def show
    # @user = User.find_by(username: params[:id])
    if this_user?
      @posts = @user.posts.all
    elsif !@user.is_private?
      @posts = @user.posts.all
    end
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

  def feed
    @user = current_user
    @feed_posts = @user.generate_feed
    @feed_posts = Array(@feed_posts)
    @suggestions = @user.suggestions
  end

  private

  def set_user
    if params.key?(:id)
      @user = User.find_by(username: params[:id])
      redirect_to user_session_path if @user.nil?
    end
  end

  def this_user?
    current_user == @user
  end
end

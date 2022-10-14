class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[following followers]

  def show
    @allowed = if current_user.present?
                 user == current_user || user.public? || user.private? && current_user.following?(user)
               else
                 user.public?
               end
    @posts = user.posts.all if @allowed
  end

  def following
    authorize user
    @title = 'Following'
    @users = user.following
    render 'show_follow'
  end

  def followers
    authorize user
    @title = 'Followers'
    @users = user.followers
    render 'show_follow'
  end

  private

  def user
    @user ||= User.find_by!(username: params[:id])
  end
end

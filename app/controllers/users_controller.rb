class UsersController < ApplicationController
  before_action :set_user
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(username: params[:id])
    if this_user?
      @posts = @user.posts.all
    elsif !@user.is_private?
      @posts = @user.posts.all
    end
  end

  private

  def set_user
    @user = User.find_by(username: params[:id])
  end

  def this_user?
    current_user == @user
  end
end

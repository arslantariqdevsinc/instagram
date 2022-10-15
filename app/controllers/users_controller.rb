class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[following]

  def index
    @users = User.all
    render json: @users
  end

  def show
    @allowed = if current_user.present?
                 user == current_user || user.public? || user.private? && current_user.following?(user)
               else
                 user.public?
               end
    @posts = user.posts.all if @allowed
  end

  def following
    # authorize user
    @title = 'Following'
    @users = user.following
    byebug

    respond_to do |format|
      format.html { render template: 'users/show_follow'}
      format.json { render json: @users }
    end
  end

  def followers
    # authorize user
    @title = 'Followers'
    @users = user.followers
    respond_to do |format|
      format.html { render template: 'users/show_follow'}
      format.json { render json: @users }
    end
  end


  private

  def user
    @user ||= User.find_by!(username: params[:id])
  end
end

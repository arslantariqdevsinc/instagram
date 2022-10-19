class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show following]

  def index
    render json: User.all
  end

  def show
    @allowed = if current_user.present?
                 user == current_user || user.public? || user.private? && current_user.following?(user)
               else
                 user.public?
               end
    @posts = user.posts.all if @allowed
    respond_to do |format|
      format.html
      format.json { render json: user }
    end
  end

  def following
    authorize user
    @title = 'Following'
    @users = user.following
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

    rescue ActiveRecord::RecordNotFound
      render  json: { error: "resource not found" }, status: :not_found

  end


  private

  def user
    @user ||= User.find_by!(username: params[:id])
  end
end

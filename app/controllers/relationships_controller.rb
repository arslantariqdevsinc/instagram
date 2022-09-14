class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    @status = current_user.following?(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def update
    @relationship = Relationship.find(params[:id])
    @relationship.accepted!
    @user_id = @relationship.follower_id

    flash.now[:notice] = 'Request accepted successfully'
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end

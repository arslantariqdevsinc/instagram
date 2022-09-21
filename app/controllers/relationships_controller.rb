class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    @relationship = Relationship.new(followed_id: @user.id, follower_id: current_user.id)
    authorize relationship
    if relationship.save
      flash[:notice] = 'Relationship saved successfully.'
    else
      flash[:alert] = 'Relationship could not be saved successfully.'
    end
  end

  def update
    authorize relationship
    relationship.accepted!
    @user_id = relationship.follower_id
    flash.now[:notice] = 'Request accepted successfully'
  end

  def destroy
    authorize relationship
    @user = relationship.followed
    relationship.destroy
  end

  private

  def relationship
    @relationship ||= Relationship.find(params[:id])
  end
end

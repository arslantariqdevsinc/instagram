class LikesController < ApplicationController
  def create
    @like = current_user.likes.new(like_params)
    @like.save
    @likeable = @like.likeable
    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: @likeable) }
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @likeable = @like.likeable
    @like.destroy
    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: post_path) }
    end
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end

  def set_user
    @user = current_user
  end
end

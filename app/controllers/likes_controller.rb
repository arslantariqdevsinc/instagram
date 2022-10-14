class LikesController < ApplicationController
  def create
    @like = current_user.likes.new(like_params)
    authorize @like
    respond_to do |format|
      if @like.save
        @likeable = @like.likeable
        format.js
      else
        format.html { redirect_back(fallback_location: @likeable) }
      end
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    authorize @like
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
end

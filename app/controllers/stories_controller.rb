class StoriesController < ApplicationController
  before_action :set_user, only: %i[create destroy]
  before_action :set_story, only: %i[destroy]

  def new
    @story = Story.new
  end

  def create
    @story = @user.stories.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to story_url(@story), notice: 'Story was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html do
        redirect_back fallback_location: authenticated_root_path, notice: 'Story was successfully destroyed.'
      end
    end
  end

  private

  def set_story
    @story = Story.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to stories_path
  end

  def set_user
    @user = current_user
  end

  def story_params
    params.require(:story).permit(:body, :attachment)
  end
end

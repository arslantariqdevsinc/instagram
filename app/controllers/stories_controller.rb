class StoriesController < ApplicationController
  before_action :set_user, only: %i[create edit destroy update]
  before_action :set_story, only: %i[show edit update destroy]

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

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to story_url(@story), notice: 'Story was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1 or /stories/1.json
  def destroy
    @story.destroy
    respond_to do |format|
      format.html do
        redirect_back fallback_location: authenticated_root_path, notice: 'Story was successfully destroyed.'
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to stories_path
  end

  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def story_params
    params.require(:story).permit(:body, :attachment)
  end
end

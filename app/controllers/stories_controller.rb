class StoriesController < ApplicationController
  before_action :set_user, only: :index

  def index
    @stories = @user.stories.all
    respond_to do |format|
      format.html
      format.json do
        render json: @stories
      end
    end
  end

  def show
    render json: story
  end


  def new
    @story = current_user.stories.new
    authorize story
  end

  def create
    @story = current_user.stories.new(story_params)
    authorize story
    if story.save
      redirect_to authenticated_root_path, notice: 'Story was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize story
    story.destroy
    redirect_back fallback_location: authenticated_root_path, notice: 'Story was successfully destroyed.'
  end

  private

  def story
    @story ||= Story.find(params[:id])
  end

  def set_user
    @user = User.find_by!(username: params[:user_id])

    rescue ActiveRecord::RecordNotFound
      render  json: { error: "resource not found" }, status: :not_found
  end

  def story_params
    params.require(:story).permit(:body, :attachment)
  end
end

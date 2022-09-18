class PostsController < ApplicationController
  before_action :set_user, only: %i[create edit destroy update]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[create edit update destroy new]

  def index
    @posts = Post.all
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit
    authorize @post
  end

  def create
    @post = @user.posts.new(post_params)
    authorize @post
    respond_to do |format|
      if @post.save
        format.turbo_stream
        format.html { redirect_to posts_path, notice: 'Post has been saved successfully.' }
      else
        # FIX THIS, INSTEAD OF GOING TO HTML AND RENDERING THE MODAL AGAIN. MAKE IT A TURBO_STREAM RESPONSE LIKE COMMENTS
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: authenticated_root_path, notice: 'Post was successfully destroyed.'
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path
    nil
  end

  def set_user
    @user = current_user
  end

  def post_params
    params.require(:post).permit(:body, images: [])
  end
end

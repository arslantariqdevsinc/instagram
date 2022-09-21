class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @posts = policy_scope(Post)
  end

  def show
    authorize post
    @comments = post.comments
  end

  def new
    @post = current_user.posts.new
    authorized post
  end

  def edit
    authorize post
    post
  end

  def create
    @post = current_user.posts.new(post_params)
    authorize post
    respond_to do |format|
      if post.save
        format.turbo_stream
        format.html { redirect_to posts_path, notice: 'Post has been saved successfully.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize post
    @comments = post.comments
    respond_to do |format|
      if post.update(post_params)
        format.turbo_stream
        format.html { redirect_to post_url(post), notice: 'Post was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize post
    post.destroy
    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: authenticated_root_path, notice: 'Post was successfully destroyed.'
      end
    end
  end

  private

  def post
    @post ||= Post.includes(:comments).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, images: [])
  end
end

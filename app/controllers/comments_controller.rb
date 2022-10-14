class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create]

  def create
    @comment = @post.comments.new(comment_params.merge(user: current_user))
    authorize comment
    respond_to do |format|
      if comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
      else
        format.html { redirect_to @post, notice: 'Comment was not created.'  }
      end
      format.turbo_stream
    end
  end

  def edit
    authorize comment
  end

  def update
    authorize comment
    respond_to do |format|
      if comment.update(comment_params)
        format.html { redirect_to comment_url(comment), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
      format.turbo_stream
    end
  end

  def destroy
    authorize comment
    comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to comment.post, notice: 'Comment was successfully destroyed.' }
    end
  end

  private

  def comment
    @comment ||= Comment.includes(:user).find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id, :parent_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end

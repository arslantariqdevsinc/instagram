class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create]

  def create
    authorize @post, :show? # {authorize post before creating comment? neccessary?}
    @comment = @post.comments.new(comment_params)
    authorize comment
    respond_to do |format|
      if comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
      format.turbo_stream
    end
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

  def edit
    authorize comment
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
    # Should I scope this to user?
    @comment ||= Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id, :parent_id).merge(user: current_user)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end

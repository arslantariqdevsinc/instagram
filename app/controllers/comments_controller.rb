class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  include CommentsHelper

  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_post, only: %i[new]

  def new
    @comment = @post.comments.new(parent_id: params[:parent_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        @new_comment = Comment.new
        flash.now[:notice] = 'Comment created successfully.'
        format.turbo_stream
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@post, @comment),
                                                    partial: 'comments/form',
                                                    locals: { comment: @comment, post: @post })
        end
        flash.now[:notice] = @comment.errors.full_messages.to_sentence
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream
        format.html { redirect_to comment_url(@comment), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @comment.post, notice: 'Comment was successfully destroyed.' }
    end
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Comment not found.'
    redirect_back fallback_location: authenticated_root_path
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id).merge(post_id: params[:post_id])
  end

  def set_user
    @user = current_user
  end

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Post not found.'
    redirect_back fallback_location: authenticated_root_path
  end
end

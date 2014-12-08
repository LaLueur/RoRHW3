class CommentsController < ApplicationController

  COMMENT_CONTAINER_ID_PREFIX = 'comment-id-'

  def index
    @comments = Comment.all
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    render partial: 'comments/form'
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user if current_user
    @comment_container_id_prefix = COMMENT_CONTAINER_ID_PREFIX
    if @comment.save
      render partial: 'comments/comment', locals: {comment: @comment}
    else
      render :new, status: 403
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    comment_container_id = '#' + COMMENT_CONTAINER_ID_PREFIX + @comment.id.to_s
    comment_deleted = false
    message = 'Sorry, you can not delete this comment. If it is yours just login please.'
    unless current_user != @comment.user
      if @comment.destroy
        message = 'Your comment is deleted.'
        comment_deleted = true
      end
    end
    respond_to do |format|
      format.html { redirect_to @post, notice: message }
      format.js {render json: {message: message,
                               comment_container_id: comment_container_id,
                               comment_deleted: comment_deleted}.to_json }
      format.json { head :no_content }
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end

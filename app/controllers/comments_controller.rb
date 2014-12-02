class CommentsController < ApplicationController
#ToDo only logged in users should have the right to leave comments
  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user if current_user
    if @comment.save
      render partial: 'comments/comment', locals: {comment: @comment}
    else
      render :new, status: 403
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if current_user != @comment.user
      message = 'Sorry, you can not delete this comment. If it is yours just login please.'
    else
      @comment.destroy
      message = 'Your comment is deleted.'
    end
    respond_to do |format|
      format.html { redirect_to @post, notice: message }
      format.js {render json: {message: message, total_score: @post.total_score}.to_json }
      format.json { head :no_content }
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end

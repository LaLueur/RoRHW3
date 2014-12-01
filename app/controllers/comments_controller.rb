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
      render partial: "comments/comment", locals: {comment: @comment}
    else
      render :new, status: 403
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    redirect_to @post
  end


  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end

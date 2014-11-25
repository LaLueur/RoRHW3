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
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@comment.post), notice: "Comment created."
    else
      render :new
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end

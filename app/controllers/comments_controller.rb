class CommentsController < ApplicationController

  COMMENT_CONTAINER_ID_PREFIX = 'comment-id-'

  def index
    @comments = Comment.all
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @comment.parent_id = params[:parent_id]
    render partial: 'comments/form'
  end

  def create
    @post = Post.find(params[:post_id])
    @comment_container_id_prefix = COMMENT_CONTAINER_ID_PREFIX
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

  def vote
    @comment = Comment.find(params[:comment_id])
    message = 'Error'
    if current_user and current_user != @comment.user
      @vote = Vote.find_by_user_id_and_votable_id_and_votable_type(current_user.id, @comment.id, @comment.class.name)
      if @vote
        if @vote.score.to_s == params[:score]
          message = "You can't vote twice."
        else
          @vote.score = params[:score]
          @vote.destroy
          message = 'Your vote is reverted.'
        end
      else
        @vote = Vote.new(:user => current_user , :score => params[:score], votable_id: @comment.id, votable_type: @comment.class.name)
        if @vote.save
          message = 'Your vote is counted.'
        else
          message = 'Unsaved.'
        end
      end
    else
      message = 'Please login first!'
    end

    respond_to do |format|
      format.html { redirect_to @comment.post, notice: message }
      #format.js {render json: {message: message, total_score: @post.total_score}.to_json }
      format.json { head :no_content }
    end


  end


  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_id)
  end
end

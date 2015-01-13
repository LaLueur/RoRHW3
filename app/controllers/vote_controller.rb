class VoteController < ApplicationController
  before_action :type
  before_action :check_auth, only: [:type, :vote]

  def vote
    message = 'Error'
    if current_user
      @vote = Vote.find(user: current_user.id, votable_id: @post.id, votable_type: 'post')
      if @vote
        if @vote.score.to_s == params[:score]
          message = "You can't vote twice."
        else
          @vote.score = params[:score]
          @vote.destroy
          message = 'Your vote is reverted.'
        end
      else
        @vote = @type.votes.build(:user => current_user , :score => params[:score])
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
      format.html { redirect_to @post, notice: message }
      format.json { head :no_content }
    end
  end



  private

  def type
    @type = Post.find(params[:post_id])
    @type = Comment.find(params[:comment_id]) if params.include?(:comment_id)
  end

  def check_auth
    if current_user != @type.user
      flash[:notice] = "Sorry, you can not update, edit or delete this post. If it is yours just login please."
      redirect_to post_path
    end
  end
end
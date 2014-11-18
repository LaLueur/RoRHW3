class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_auth, only: [:edit, :update, :destroy]



  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    respond_to do |format|
      format.html
      format.json { render json: @posts, except: :updated_at, :include => {:user => {:only => [:name]}}}
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    #@post = Post.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @post, except: :updated_at, :include => {:user => {:only => [:name]}}}
    end
  end

  # GET /posts/new
  def new
    if current_user
      @post = Post.new
    else
      redirect_to sessions_login_path
    end
  end

  # GET /posts/1/edit
  def edit

  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      @post.user = current_user if current_user
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_path, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end

  def check_auth
    if current_user != @post.user
      flash[:notice] = "Sorry, you can not update, edit or delete this post. If it is yours just login please."
      redirect_to post_path
    end
  end

end

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_auth, only: [:edit, :update, :destroy]
  before_action :update_views



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
      @action_path = posts_path
      @method = :post
    else
      redirect_to sessions_login_path
    end
  end

  # GET /posts/1/edit
  def edit
    @action_path = post_path @post
    @method = :put
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new
    @post.title = params[:title]
    @post.body = params[:body]
    @post.user = current_user if current_user
    @tags = params[:tags].split(',') unless params[:tags].blank?

    respond_to do |format|

      Post.transaction do
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @post }
          create_tags(@post, @tags)
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      @post.title = params[:title]
      @post.body = params[:body]
      @tags = params[:tags].split(',') unless params[:tags].blank?
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
        create_tags(@post, @tags)
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
    params.require(:post).permit(:title, :body)
  end

  def check_auth
    if current_user != @post.user
      flash[:notice] = "Sorry, you can not update, edit or delete this post. If it is yours just login please."
      redirect_to post_path
    end
  end

  def create_tags(post, tags)
    unless tags.blank?
      tags.each { |tag_val|
        tag = Tag.find_by_name tag_val
        if tag.blank?
          tag = Tag.new()
          tag.name = tag_val
        end
        create_post_tag(post, tag) if tag.save
      }
    end
  end

  def create_post_tag(post, tag)
    post_tag = PostTag.find_by_post_id_and_tag_id(post.id, tag.id)
    if post_tag.blank?
      post_tag = PostTag.new
      post_tag.post = post
      post_tag.tag = tag
      post_tag.save
    end
  end

end

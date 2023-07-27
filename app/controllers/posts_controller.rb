class PostsController < ApplicationController
  before_action :set_post, except: [:index, :create]

  def index
    @post = Post.new
    @posts = Post.includes(:author, :likes, comments: [:likes]).order(created_at: :desc).all
  end

  def show
  end
  
  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      redirect_to root_path
    end
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save 
        format.turbo_stream
      else
        redirect_to root_url
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body)
  end
end

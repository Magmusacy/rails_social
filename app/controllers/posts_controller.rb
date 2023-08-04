class PostsController < ApplicationController
  before_action :set_post, except: [:index, :create]

  def index
    @post = Post.new
    @posts = Post.includes(:likes, :author, comments: [:likes, :post, :author]).order(created_at: :desc, "comments.created_at": :desc).with_attached_image.all
  end

  def show
  end
  
  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      flash[:alert] = @post.errors.full_messages.join(" ")
      redirect_to root_path
    end
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save 
        format.turbo_stream
      else
        flash[:alert] = @post.errors.full_messages.join(" ")
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, :image)
  end
end

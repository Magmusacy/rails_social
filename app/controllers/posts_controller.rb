class PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all.includes(:author, :comments).order(created_at: :desc)
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
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end

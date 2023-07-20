class PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc)
  end

  def create
    @post = current_user.posts.build(post_params)
    p @post
    respond_to do |format|
      if @post.save 
        format.turbo_stream
      else
        redirect_to root_url
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end

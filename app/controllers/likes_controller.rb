class LikesController < ApplicationController
    def create
        if params.has_key?(:post_id)
            @likeable = Post.find(params[:post_id])
            @like = @likeable.likes.build(user_id: current_user.id)
            
            respond_to do |format|
                if @like.save
                    format.turbo_stream
                else
                    format.html { redirect_to root_path }
                end
            end
        end
    end

    def destroy
        @like = Like.find(params[:id])
        if @like.likeable_type == "Post"
            @likeable = Post.find(@like.likeable_id)
        end
        @like.destroy   

        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to root_path }
        end    
    end
end

class LikesController < ApplicationController
    def create
        likeable_type = params.has_key?(:post_id) ? "Post" : "Comment"
        likeable_id = params[:"#{likeable_type.downcase}_id"]
        @likeable = likeable_type.constantize.find(likeable_id)
        @like = @likeable.likes.build(user_id: current_user.id)
        
        respond_to do |format|
            if @like.save
                format.turbo_stream
            else
                format.html { redirect_to root_path }
            end
        end
    end

    def destroy
        @like = Like.find(params[:id])
        @likeable = @like.likeable_type.constantize.find(@like.likeable_id)
        @like.destroy   

        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to root_path }
        end    
    end
end

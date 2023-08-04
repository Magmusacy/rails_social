class CommentsController < ApplicationController
    def create
        @comment = current_user.comments.build(comment_params)

        respond_to do |format|
            if @comment.save
                format.turbo_stream
            else
                flash[:alert] = @post.errors.full_messages.join(" ")
                format.html { redirect_to root_path }
            end
        end
    end

    def destroy
        @comment = current_user.comments.find(params[:id])
        @comment.destroy

        respond_to do |format|
            format.turbo_stream
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:body, :post_id)
    end
end

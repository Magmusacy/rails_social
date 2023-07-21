class CommentsController < ApplicationController
    def create
        @comment = current_user.comments.build(comment_params)

        respond_to do |format|
            if @comment.save
                format.turbo_stream
            else
                redirect_to root_path
            end
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:body, :post_id)
    end
end

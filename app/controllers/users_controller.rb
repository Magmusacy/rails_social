class UsersController < ApplicationController
    def show
        @user = User.includes(posts: [:likes, {comments: [:likes, :author, :post]}]) 
                    .order("posts.created_at DESC", "comments.created_at DESC")
                    .find(params[:id])
        @invitation = Invitation.find_invitation(current_user, @user).take
    end    
end

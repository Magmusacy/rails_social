class InvitationsController < ApplicationController
    def create
        @invitation = current_user.invitations.build(friend_id: params[:friend_id])
        @friend = User.find(params[:friend_id])

        respond_to do |format|
            if @invitation.save
                if params.has_key?(:user_profile)
                    user = User.find(params[:user_profile])
                    format.html { redirect_to user }
                else
                    format.turbo_stream
                    format.html { redirect_to root_path }
                end
            else
                flash[:alert] = @post.errors.full_messages.join(" ")
                format.html { redirect_to root_path }
            end
        end
    end

    def update
        @invitation = Invitation.find_invitation(params[:inviting_user_id], current_user.id).take
        
        respond_to do |format|
            if @invitation.update_attribute(:confirmed, true)
                if params.has_key?(:user_profile)
                    user = User.find(params[:user_profile])
                    format.html { redirect_to user }
                else
                    format.turbo_stream
                    format.html { redirect_to root_path }
                end
            else
                flash[:alert] = @post.errors.full_messages.join(" ")
                format.html { redirect_to root_path }
            end
        end        
    end

    def destroy
        @invitation = current_user.invitations.find(params[:id])
        @friend = @invitation.friend
        @invitation.destroy

        respond_to do |format|
            if params.has_key?(:user_profile)
                user = User.find(params[:user_profile])
                format.html { redirect_to user }
            else
                format.turbo_stream 
                format.html { redirect_to root_path }
            end
        end
    end

    def friends
        @friends = current_user.friends
        @invitations = Invitation.confirmed.where(user_id: current_user.id).or(Invitation.confirmed.where(friend_id: current_user.id))
    end

    def suggested
        @suggested_friends = current_user.suggested_friends
        @invitations = current_user.invitations.where(confirmed: false)
    end

    def pending
        @pending_invitations = current_user.pending_invitations
    end
end

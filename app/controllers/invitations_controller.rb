class InvitationsController < ApplicationController
    def create
        @invitation = current_user.invitations.build(friend_id: params[:friend_id])
        @friend = User.find(params[:friend_id])

        respond_to do |format|
            if @invitation.save
                format.turbo_stream
                format.html { redirect_to root_path }
            else
                format.html { redirect_to root_path }
            end
        end
    end

    def update
        @invitation = Invitation.find_invitation(params[:inviting_user_id], current_user.id).take
        @invitation.confirmed = true

        respond_to do |format|
            if @invitation.save
                format.turbo_stream
                format.html { redirect_to root_path }
            else
                format.html { redirect_to root_path }
            end
        end        
    end

    def destroy
        @invitation = Invitation.find(params[:id])
        @friend = @invitation.friend
        @invitation.destroy

        respond_to do |format|
            format.turbo_stream 
            format.html { redirect_to root_path }
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

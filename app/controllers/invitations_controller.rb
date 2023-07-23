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
end

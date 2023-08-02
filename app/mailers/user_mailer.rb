class UserMailer < ApplicationMailer
    default from: "magmuascy@example.com"

    def welcome_email
        @user = params[:user]
        mail(to: @user.email, subject: 'Welcome to Rails Social')
    end
end

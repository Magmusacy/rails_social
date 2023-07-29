class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:github, :google_oauth2]

  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication 
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: "Couldn't authenticate with GitHub: #{@user.errors.full_messages.join("\n")}"
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: "Couldn't authenticate with Google: #{@user.errors.full_messages.join("\n")}"
    end
  end

  def failure
    redirect_to root_path
  end
end
# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    if @user.persisted? 
      UserMailer.with(user: @user).welcome_email.deliver_later
    end
  end
  
  # After user update's his profile, redirect to that profile
  def user_root_path
    current_user
  end

  protected

  def update_resource(resource, params)
    resource.provider.blank? ? super : resource.update_without_password(params)
  end
end

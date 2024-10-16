# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end

  # The path used after sign in.
  def after_sign_in_path_for(*)
    books_path
  end

  # The path used after sign out.
  def after_sign_out_path_for(*)
    new_user_session_path
  end
end

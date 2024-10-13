# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  protected

  def after_resetting_password_path_for(*)
    new_user_session_path
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(*)
    new_user_session_path
  end
end

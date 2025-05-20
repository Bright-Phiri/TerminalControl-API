# frozen_string_literal: true

class Api::V1::PasswordsController < ApplicationController
    skip_before_action :authorize_request

    def forgot_password
      user = User.find_by(email_address: user_params[:email_address])
      raise InvalidEmail, "We could not find an account with that email address." unless user.present?

      user.generate_password_token!
      UserMailer.with(user:).send_password_reset.deliver_later
      render_ok nil, "A password reset token has been sent to your email"
    end

    def verify_password_reset_token
      token = User.find_by(reset_password_token: user_params[:reset_password_token])
      if token.present? && token.password_token_valid?
        render_ok nil, "Token is valid. Please enter a new password to reset your account."
      else
        render_bad_request "Token not valid or expired. Please request a new one.", nil
      end
    end

    def reset_password
      user = User.find_by(email_address: user_params[:email_address])
      raise InvalidEmail, "We could not find an account with that email address." unless user.present?

      if user.reset_password!(user_params[:password], user_params[:password_confirmation])
        render_ok nil, "Password reset successful. You can now log in with your new password."
      else
        render_unprocessable_entity "Failed to update password", user.errors.full_messages
      end
    end

    private

    def user_params
      params.permit(:email_address, :reset_password_token, :password, :password_confirmation)
    end
end

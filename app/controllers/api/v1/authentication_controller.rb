# frozen_string_literal: true

class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request
  wrap_parameters false

  def login
    if User.exists?
      user = User.find_by(user_name: user_params[:user_name])
      raise ExceptionHandler::InvalidUsername unless user.present?

      authenticate_user(user)
    else
      render_not_found "No user account found", nil
    end
  end

  private

  def authenticate_user(user)
    raise ExceptionHandler::InvalidCredentials unless user.authenticate(user_params[:password])

    if user.active_status?
      token = encode_token({ user_id: user.id, exp: 24.hours.from_now.to_i })
      render_ok({ user:, token: token }, "Access granted")
    else
      render_locked "User account disabled", nil
    end
  end

  def user_params
    params.permit(:user_name, :password)
  end
end

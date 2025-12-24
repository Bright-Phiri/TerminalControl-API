# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  include JsonWebToken
  include AbilityPermissions

  include CanCan::ControllerAdditions

  before_action :authorize_request

  def decode_action_cable_token(auth_header)
    token = auth_header.split(' ')[1]
    decode_token(token)
  end

  private

  def logged_in?
    current_user.present?
  end

  def current_user
    return unless decoded_token

    user_id = decoded_token[0]["user_id"]
    User.find(user_id)
  end

  def authorize_request
    return render_unauthorized("Token missing") if request.authorization.blank?
    return render_unauthorized("Invalid token format") unless request.authorization.starts_with?("Bearer ")
    return render_unauthorized("Unauthorized: Invalid or expired token") unless logged_in?
  end

  def authenticate!
    api_key = request.headers["X-API-KEY"]
    return render_unauthorized("API key is missing") if api_key.blank?
    return render_unauthorized("Unauthorized") unless valid_api_key?(api_key)
  end

  def valid_api_key?(api_key)
    api_key == Rails.application.credentials.api_key
  end

  def decoded_token
    token = request.authorization.split(" ")[1]
    decode_token(token)
  end
end

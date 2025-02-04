# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authorize_request

  private

  def encode_token(payload)
    JWT.encode(payload, hmac_secret)
  end

  def logged_in?
    logged_in_user.present?
  end

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token[0]["user_id"]
    User.find_by(id: user_id)
  end

  def authorize_request
    if auth_header.blank?
      render_unauthorized "Token missing"
    else
      render_unauthorized "Invalid token format" and return unless auth_header.starts_with?("Bearer ")

      render_unauthorized "Unauthorized: Invalid or expired token" unless logged_in?
    end
  end

  def authenticate!
    api_key = request.headers["X-API-KEY"]
    if api_key.blank?
      render_unauthorized "API key is missing"
    else
      unless valid_api_key?(api_key)
        render_unauthorized "Unauthorized"
      end
    end
  end

  def valid_api_key?(api_key)
    api_key == Rails.application.credentials.api_key
  end

  def auth_header
    request.authorization
  end

  def decode_token(token)
    JWT.decode(token, hmac_secret, true, { algorithm: "HS256" })
  rescue JWT::DecodeError
    nil
  end

  def decoded_token
    token = auth_header.split(" ")[1]
    decode_token(token)
  end

  def render_unauthorized(message)
    render json: { status: "login", message: }, status: :unauthorized
  end

  def hmac_secret
    Rails.application.credentials.secret_key_base
  end
end

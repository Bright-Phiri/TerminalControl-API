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
    User.find(user_id)
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

  def hmac_secret
    Rails.application.credentials.secret_key_base
  end

  def render_unauthorized(message)
    render json: error_response_body(message, nil, nil), status: :unauthorized
  end

  def render_error(message = "OK", data = nil, errors = nil)
    render json: error_response_body(message, data, errors), status: :ok
  end

  def render_ok(data, message = "OK")
    render json: success_response_body(data, message), status: :ok
  end

  def render_created(data, message = "Created")
    render json: success_response_body(data, message), status: :created
  end

  def render_bad_request(message = "Bad Request", errors)
    render json: error_response_body(message, nil, errors), status: :bad_request
  end

  def render_forbidden(message = "Forbidden", errors)
    render json: error_response_body(message, nil, errors), status: :forbidden
  end

  def render_locked(message = "Locked", errors)
    render json: error_response_body(message, nil, errors), status: :locked
  end

  def render_unprocessable_entity(message = "Unprocessable Entity", errors)
    render json: error_response_body(message, nil, errors), status: :unprocessable_entity
  end

  def render_not_found(message = "Not Found", errors)
    render json: error_response_body(message, nil, errors), status: :not_found
  end

  private

  def success_response_body(data, message = "OK", errors = nil)
    {
      success: true,
      message: message,
      data: data,
      errors: errors
    }
  end

  def error_response_body(message, data = nil, errors = nil)
    {
      success: false,
      message: message,
      data: data,
      errors: errors
    }
  end
end

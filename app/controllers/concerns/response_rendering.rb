# frozen_string_literal: true

module ResponseRendering
  extend ActiveSupport::Concern

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
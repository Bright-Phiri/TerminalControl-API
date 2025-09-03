# frozen_string_literal: true

module JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
  rescue JWT::DecodeError
    nil
  end
end

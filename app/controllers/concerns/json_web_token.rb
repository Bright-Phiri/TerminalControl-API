# frozen_string_literal: true

module JsonWebToken
  SECRET_KEY = Rails.application.credentials.dig(:jwt, :secret_key)
  ISSUER     = Rails.application.credentials.dig(:jwt, :issuer)
  AUDIENCE   = Rails.application.credentials.dig(:jwt, :audience)

  module_function

  def encode_token(payload, exp: TOKEN_EXPIRY_DURATION.from_now.to_i)
    payload[:iss] = ISSUER
    payload[:aud] = AUDIENCE
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def decode_token(token)
    options = {
      algorithm: "HS256",
      verify_iss: true,
      iss: ISSUER,
      verify_aud: true,
      aud: AUDIENCE,
      verify_expiration: true
    }
    JWT.decode(token, SECRET_KEY, true, options)
  rescue JWT::DecodeError
    nil
  end
end

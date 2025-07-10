# frozen_string_literal: true

module DefaultCredentials
  extend ActiveSupport::Concern

  included do
    after_initialize :set_default_password, if: :new_record?, unless: :is_admin?
    after_create_commit :send_default_password_email, unless: :is_admin?
  end

  def set_default_password
    @default_password = SecureRandom.alphanumeric(8)
    self.password ||= @default_password
    self.password_confirmation ||= @default_password
  end

  def send_default_password_email
    UserMailer.send_default_password(self, @default_password).deliver_later
  end

  def is_admin?
    role == VALID_ROLES.last
  end
end

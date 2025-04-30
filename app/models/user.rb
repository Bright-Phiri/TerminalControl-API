# frozen_string_literal: true

class User < ApplicationRecord
  include DefaultCredentials

  enum :status, [ :active, :disabled ], suffix: true, default: :active

  VALID_ROLES = [ "Officer", "Admin" ].freeze

  has_secure_password

  validates :password, confirmation: true, allow_nil: true, on: :update

  validates :role, inclusion: { in: VALID_ROLES }
  with_options uniqueness: { case_sensitive: false } do
    validates :user_name, presence: true, format: { without: /\s/, message: "must contain no spaces" }
    validates :email_address, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "is invalid" }
    validates :phone_number, phone_number: true, allow_blank: true
  end

  with_options if: :is_admin? do |admin|
    admin.validates :first_name, :last_name, :phone_number, presence: true, on: :update
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!(validate: false, touch: false)
  end

  def password_token_valid?
    (reset_password_sent_at + 2.hours) > Time.now.utc
  end

  def reset_password!(password, password_confirmation)
    self.reset_password_token = nil
    self.password = password
    self.password_confirmation = password_confirmation
    save!(validate: false)
  end

  def is_admin?
    role == VALID_ROLES.last
  end

  private

  def generate_token
    SecureRandom.hex(4)
  end
end

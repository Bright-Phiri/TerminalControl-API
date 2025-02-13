# frozen_string_literal: true

class User < ApplicationRecord
  enum :status, [ :active, :disabled ], suffix: true, default: :active

  VALID_ROLES = [ "Officer", "Admin" ].freeze

  has_secure_password
  validates :role, inclusion: { in: VALID_ROLES }
  with_options uniqueness: { case_sensitive: false } do
    validates :user_name, presence: true, format: { without: /\s/, message: "must contain no spaces" }
    validates :email_address, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "is invalid" }
    validates :phone_number, phone_number: true, allow_blank: true
  end

  with_options if: :is_admin? do |admin|
    admin.validates :first_name, :last_name, :phone_number, presence: true, on: :update
  end

  def is_admin?
    role == VALID_ROLES.last
  end
end

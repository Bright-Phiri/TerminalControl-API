# frozen_string_literal: true

class Taxpayer < ApplicationRecord
  with_options dependent: :destroy do |assoc|
    assoc.has_many :terminals
    assoc.has_one :subscription
  end
  has_secure_password

  with_options presence: true do
    validates :tin, :name, :email_address, :phone_number, uniqueness: true
  end

  after_initialize :set_default_password, if: :new_record?
  after_create_commit :send_default_password_email, :send_default_password_email
  scope :search, ->(query) { 
    where("name ILIKE :query OR tin ILIKE :query OR email_address ILIKE :query OR phone_number ILIKE :query", query: "%#{query}%") if query.present? 
  }

  private

  def set_default_password
    @default_password = SecureRandom.alphanumeric(8)
    self.password = @default_password
  end

  def send_default_password_email
    TaxpayerMailer.send_default_password(self, @default_password).deliver_later
  end

  def update_live_dashboard
    LiveDashboardUpdateJob.perform_later
  end
end

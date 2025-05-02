# frozen_string_literal: true

class Taxpayer < ApplicationRecord
  include DefaultCredentials

  with_options dependent: :destroy do |assoc|
    assoc.has_many :terminals
    assoc.has_one :subscription
  end
  has_secure_password

  with_options presence: true do
    validates :tin, :name, :email_address, :phone_number, uniqueness: true
  end

  default_scope { order(:created_at).reverse_order }
  scope :search, ->(query) { 
    where("name ILIKE :query OR tin ILIKE :query OR email_address ILIKE :query OR phone_number ILIKE :query", query: "%#{query}%") if query.present? 
  }

  private

  def update_live_dashboard
    LiveDashboardUpdateJob.perform_later
  end
end

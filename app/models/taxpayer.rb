# frozen_string_literal: true

class Taxpayer < ApplicationRecord
  include DefaultCredentials
  include PgSearch::Model

  with_options dependent: :destroy do |assoc|
    assoc.has_many :terminals
    assoc.has_one :subscription
  end
  has_secure_password

  with_options presence: true do
    validates :tin, :name, :email_address, :phone_number, uniqueness: true
  end

  default_scope { order(:created_at).reverse_order }
  pg_search_scope :search,
    against: [:name, :tin, :email_address, :phone_number],
    using: {
    tsearch: { prefix: true }
    }

  private

  def update_live_dashboard
    LiveDashboardUpdateJob.perform_later
  end
end

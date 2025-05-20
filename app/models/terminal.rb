# frozen_string_literal: true

class Terminal < ApplicationRecord
  include CreatedAtFormatting
  enum :status, [ :active, :blocked ], suffix: true, default: :active

  belongs_to :taxpayer, counter_cache: true

  validates :terminal_id, :terminal_label, :activation_date, presence: true
  validates :terminal_id, uniqueness: true

  after_create_commit { LiveDashboardUpdateJob.perform_later }

  default_scope { order(:created_at).reverse_order }
  scope :search, ->(query) {
    joins(:taxpayer).where("terminal_label ILIKE :query OR taxpayers.name ILIKE :query", query: "%#{query}%") if query.present?
  }
end

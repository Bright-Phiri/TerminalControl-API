# frozen_string_literal: true

class Terminal < ApplicationRecord
  include PgSearch::Model
  include CreatedAtFormatting
  include LiveDashboardNotifiable

  enum :status, [ :active, :blocked ], suffix: true, default: :active

  belongs_to :taxpayer, counter_cache: true

  validates :terminal_id, :terminal_label, :activation_date, presence: true
  validates :terminal_id, uniqueness: true

  default_scope { order(:created_at).reverse_order }
  pg_search_scope :search,
    against: :terminal_label,
    associated_against: {
      taxpayer: :name
    },
    using: {
      tsearch: { prefix: true }
    }
end

# frozen_string_literal: true

class Terminal < ApplicationRecord
  enum :status, [ :active, :blocked ], suffix: true, default: :active

  belongs_to :taxpayer, counter_cache: true

  validates :terminal_id, :terminal_label, :activation_date, presence: true
  validates :terminal_id, uniqueness: true

  scope :active, -> { where(status: "active") }
end

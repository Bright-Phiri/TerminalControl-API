# frozen_string_literal: true

class Terminal < ApplicationRecord
  belongs_to :taxpayer, counter_cache: true
  enum :status, [ :active, :blocked ], suffix: true, default: :active
  validates :terminal_id, :terminal_label, :activation_date, presence: true
end

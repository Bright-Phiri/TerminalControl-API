# frozen_string_literal: true

class Subscription < ApplicationRecord
  enum :status, [ :active, :expired ], suffix: true, default: :active
  belongs_to :taxpayer
  has_one :payment, dependent: :destroy

  validates :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }

  scope :active, -> { where(status: :active) }

  def expired?
    end_date < Date.today
  end
end

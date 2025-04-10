# frozen_string_literal: true

class Subscription < ApplicationRecord
  enum :status, [ :active, :expired ], suffix: true, default: :active
  belongs_to :taxpayer
  has_many :payments, dependent: :destroy

  validates :start_date, presence: true

  after_commit { LiveDashboardUpdateJob.perform_later }

  scope :active, -> { where(status: :active) }

  scope :search, ->(query) {
    if query.present?
      joins(:taxpayer).where(
        "CAST(start_date AS VARCHAR) ILIKE :query OR taxpayers.tin ILIKE :query OR taxpayers.name ILIKE :query", query: "%#{query}%"
      )
    end
  }  

  def expired?
    end_date < Date.today
  end
end

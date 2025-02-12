# frozen_string_literal: true

class Subscription < ApplicationRecord
  enum :status, [ :active, :expired ], suffix: true, default: :active
  belongs_to :taxpayer
  has_many :payments, dependent: :destroy

  validates :start_date, presence: true
  validate :valid_subscription_duration

  after_commit { LiveDashboardUpdateJob.perform_later }

  scope :active, -> { where(status: :active) }

  def expired?
    end_date < Date.today
  end

  private

  def valid_subscription_duration
    if (end_date - start_date).to_i < 28 || (end_date - start_date).to_i > 365
      errors.add(:end_date, "Subscription duration must be between 1 and 12 months")
    end
  end
end

# frozen_string_literal: true

class Subscription < ApplicationRecord
  enum :status, [ :active, :expired ], suffix: true, default: :active
  belongs_to :taxpayer
  has_many :payments, dependent: :destroy

  validates :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }

  after_commit { LiveDashboardUpdateJob.perform_later }

  scope :active, -> { where(status: :active) }

  def expired?
    end_date < Date.today
  end

  def renew(months)
    self.end_date = (expired? ? Date.today : end_date) + months.months
    self.status = :active
    save!
  end
end

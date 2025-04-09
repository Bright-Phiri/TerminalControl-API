# frozen_string_literal: true

class Subscription < ApplicationRecord
  enum :status, [ :active, :expired ], suffix: true, default: :active
  belongs_to :taxpayer
  has_many :payments, dependent: :destroy

  validates :start_date, presence: true

  after_commit { LiveDashboardUpdateJob.perform_later }

  scope :active, -> { where(status: :active) }

  def expired?
    end_date < Date.today
  end
end

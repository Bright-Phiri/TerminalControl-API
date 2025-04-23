# frozen_string_literal: true

class Payment < ApplicationRecord
  VALID_PAYMENT_METHODS = [ "CASH", "TNM MPAMBA", "AIRTEL MONEY", "VISA" ].freeze

  belongs_to :subscription

  validates :payment_method, :amount, presence: true
  validates :payment_method, inclusion: { in: VALID_PAYMENT_METHODS }
  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_id, presence: { message: "Id is required for this payment method" }, unless: :cash_payment?

  after_commit { LiveDashboardUpdateJob.perform_later }

  scope :daily_revenue, -> { where(created_at: Date.current.all_day) }
  scope :weekly_revenue, -> { where(created_at: Date.current.beginning_of_week(:sunday)..Date.current.end_of_week(:sunday)) }
  scope :monthly_revenue, -> { where(created_at: Date.current.beginning_of_month..Date.current.end_of_day) }
  scope :created_in, ->(year) { where('extract(year from created_at) = ?', year) if year.present? }
  scope :statistics, -> { created_in(Date.current.year).select(:id, :created_at, 'COUNT(id)').group(:id) }
  scope :search, ->(query) {
    if query.present?
      joins(subscription: :taxpayer).where(
        "payments.payment_method ILIKE :query
         OR CAST(payments.payment_date AS VARCHAR) ILIKE :query
         OR payments.transaction_id ILIKE :query
         OR CAST(payments.amount AS VARCHAR) ILIKE :query
         OR taxpayers.tin ILIKE :query
         OR taxpayers.name ILIKE :query",
        query: "%#{query}%"
      )
    end
  }  
  private

  def cash_payment?
    payment_method == VALID_PAYMENT_METHODS.first
  end
end

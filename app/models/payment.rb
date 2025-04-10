# frozen_string_literal: true

class Payment < ApplicationRecord
  VALID_PAYMENT_METHODS = [ "CASH", "TNM MPAMBA", "AIRTEL MONEY", "VISA" ].freeze

  belongs_to :subscription

  validates :payment_method, :amount, presence: true
  validates :payment_method, inclusion: { in: VALID_PAYMENT_METHODS }
  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_id, presence: { message: "Id is required for this payment method" }, unless: :cash_payment?

  after_commit { LiveDashboardUpdateJob.perform_later }

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

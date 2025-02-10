# frozen_string_literal: true

class Payment < ApplicationRecord
  VALID_PAYMENT_METHODS = [ "CASH", "TNM MPAMBA", "AIRTEL MONEY", "VISA" ].freeze

  belongs_to :subscription

  validates :payment_method, :amount, presence: true
  validates :payment_method, inclusion: { in: VALID_PAYMENT_METHODS }
  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_id, presence: true, unless: :cash_payment?

  private

  def cash_payment?
    payment_method == VALID_PAYMENT_METHODS.first
  end
end

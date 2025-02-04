# frozen_string_literal: true

class Payment < ApplicationRecord
  VALID_PAYMENT_METHODS = [ "CASH", "TNM MPAMBA", "AIRTEL MONEY", "VISA" ].freeze

  belongs_to :taxpayer

  validates :period, :payment_method, :amount, presence: true
  validates :payment_method, inclusion: { in: VALID_PAYMENT_METHODS }
  validates :amount, numericality: { greater_than: 0 }
  validate :payment_cannot_be_duplicated_for_same_month, :period_must_be_valid_date

  private

  def payment_cannot_be_duplicated_for_same_month
    return if period.blank?

    existing_payment = taxpayer.payments.where.not(id: id)
                        .where("EXTRACT(YEAR FROM period) = ? AND EXTRACT(MONTH FROM period) = ?", period.year, period.month)
                        .exists?

    errors.add(:period, "A payment for this month already exists.") if existing_payment
  end

  def period_must_be_valid_date
    Date.parse(period.to_s) rescue errors.add(:period, "Invalid date format. Use YYYY-MM-DD.")
  end
end

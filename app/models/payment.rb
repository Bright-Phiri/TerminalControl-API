# frozen_string_literal: true

class Payment < ApplicationRecord
  include CreatedAtFormatting

  VALID_PAYMENT_METHODS = [ "CASH", "TNM MPAMBA", "AIRTEL MONEY", "VISA" ].freeze

  belongs_to :subscription

  validates :payment_method, :amount, presence: true
  validates :payment_method, inclusion: { in: VALID_PAYMENT_METHODS }
  validates :amount, numericality: { greater_than: 0 }
  validate :payment_date_cannot_be_in_the_future
  validates :transaction_id, presence: { message: "Id is required for this payment method" }, unless: :cash_payment?

  default_scope { order(:created_at).reverse_order }
  scope :daily_revenue, -> { where(created_at: Date.current.all_day) }
  scope :weekly_revenue, -> { where(created_at: Date.current.beginning_of_week(:sunday)..Date.current.end_of_week(:sunday)) }
  scope :monthly_revenue, -> { where(created_at: Date.current.beginning_of_month..Date.current.end_of_day) }
  scope :created_in, ->(year) { where("extract(year from created_at) = ?", year) if year.present? }
  scope :statistics, -> { created_in(Date.current.year).select(:id, :created_at, "COUNT(id)").group(:id) }
  scope :search, ->(query) {
  return all unless query.present?

  joins(subscription: :taxpayer).where(<<~SQL.squish, query: "%#{query}%")
    payments.payment_method ILIKE :query OR
    CAST(payments.payment_date AS TEXT) ILIKE :query OR
    payments.transaction_id ILIKE :query OR
    CAST(payments.amount AS TEXT) ILIKE :query OR
    taxpayers.tin ILIKE :query OR
    taxpayers.name ILIKE :query
  SQL
  }

  private

  def cash_payment?
    payment_method == VALID_PAYMENT_METHODS.first
  end

  def payment_date_cannot_be_in_the_future
    errors.add :payment_date, message: " cannot be in the future" unless payment_date.present? && payment_date <= Date.today
  end
end

# frozen_string_literal: true

class PaymentsRepresenter
  def initialize(payments)
    @payments = payments
  end

  def as_json
    payments.map do |payment|
      {
        id: payment.id,
        owner: payment.subscription.taxpayer.tin,
        taxpayer: payment.subscription.taxpayer.name,
        payment_date: payment.payment_date,
        amount: payment.amount,
        payment_method: payment.payment_method,
        created_at: payment.created_at
      }
    end
  end

  private

  attr_reader :payments
end

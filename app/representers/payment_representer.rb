# frozen_string_literal: true

class PaymentRepresenter
  def initialize(payment)
    @payment = payment
  end

  def as_json
    {
      id: payment.id,
      owner: payment.taxpayer.tin,
      taxpayer: payment.taxpayer.name,
      period: payment.period,
      amount: payment.amount,
      payment_method: payment.payment_method,
      created_at: payment.created_at
    }
  end

  private

  attr_reader :payment
end

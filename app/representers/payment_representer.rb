# frozen_string_literal: true

class PaymentRepresenter
  def initialize(payment)
    @payment = payment
  end

  def as_json
    {
      id: payment.id,
      owner: payment.subscription.taxpayer.tin,
      taxpayer: payment.subscription.taxpayer.name,
      payment_date: payment.payment_date.strftime("%B %d, %Y"),
      amount: payment.amount,
      payment_method: payment.payment_method,
      transaction_id: payment.transaction_id.presence || "N/A",
      created_at: payment.formatted_created_at
    }
  end

  private

  attr_reader :payment
end

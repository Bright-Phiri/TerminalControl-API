# frozen_string_literal: true

class Api::V1::PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show update destroy]

  def index
    payments = Payment.order(:created_at).reverse_order.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
  end

  def create
    subscription = Subscription.find(params[:subscription_id])

    payment = subscription.payments.create(payment_params)
    if payment.persisted?
      render_created PaymentRepresenter.new(payment).as_json, "Payment successfully created"
    else
      render_unprocessable_entity "Failed to create payment", payment.errors.full_messages
    end
  end

  def show
    render_ok PaymentRepresenter.new(@payment).as_json
  end

  def update
    if @payment.update(payment_params)
      render_ok PaymentRepresenter.new(@payment).as_json, "Payment successfully updated"
    else
      render_unprocessable_entity "Failed to update payment", @payment.errors.full_messages
    end
  end

  def destroy
    @payment.destroy!
    head :no_content
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.expect(payment: [ :payment_date, :amount, :payment_method ])
  end
end

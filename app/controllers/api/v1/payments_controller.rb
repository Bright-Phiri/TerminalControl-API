# frozen_string_literal: true

class Api::V1::PaymentsController < ApplicationController
  before_action :set_payment, only: :show

  def index
    payments = Payment.search(params[:search])
    payments = payments.order(:created_at).reverse_order.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
  end

  def show
    render_ok PaymentRepresenter.new(@payment).as_json
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.expect(payment: [ :payment_date, :amount, :payment_method ])
  end
end

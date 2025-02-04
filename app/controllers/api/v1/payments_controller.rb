# frozen_string_literal: true

class Api::V1::PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show update destroy]

  def index
    payments = Payment.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render json: { payments:, total: payments.total_entries }
  end

  def create
    taxpayer = Taxpayer.find(params[:taxpayer_id])
    payment = taxpayer.payments.create(payment_params)
    if payment.persisted?
      render json: payment, status: :created
    else
      render json: payment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json @payment
  end

  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors.full_messages, status: :unprocessable_entity
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
    params.expect(payment: [ :period, :amount, :payment_method ])
  end
end

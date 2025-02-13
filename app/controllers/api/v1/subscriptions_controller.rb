# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show renew show_payments destroy]

  def index
    subscriptions = Subscription.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ subscriptions: SubscriptionsRepresenter.new(subscriptions).as_json, total: subscriptions.total_entries })
  end

  def show
    render_ok SubscriptionRepresenter.new(@subscription).as_json
  end

  def create
    taxpayer = Taxpayer.find(params[:taxpayer_id])
    raise ExceptionHandler::SubscriptionError if taxpayer.subscription.present?

    subscription_data, transaction_data = subscription_params
    months = subscription_data[:months].to_i
    end_date = subscription_data[:start_date].to_date + months.months
    sub_params = subscription_data.except(:months)

    subscription = taxpayer.build_subscription(sub_params.merge(end_date: end_date))
    payment = nil
    ActiveRecord::Base.transaction do
      subscription.save!
      payment = subscription.payments.create!(transaction_data)
    end

    if subscription.persisted? && payment.persisted?
      render_created SubscriptionRepresenter.new(subscription).as_json, "Subscription and payment successfully created"
    else
      errors = subscription.errors.full_messages + payment.errors.full_messages
      render_unprocessable_entity "Failed to create subscription or payment", errors
    end
  end

  def renew
    @subscription = Subscription.find(params[:id])
    subscription_data, payment_data = subscription_params
    months = subscription_data[:months].to_i
    new_end_date = @subscription.end_date + months.months
    payment = @subscription.payments.build(payment_data)
    sub_params = subscription_data.except(:months)

    ActiveRecord::Base.transaction do
      @subscription.update!(sub_params.merge(end_date: new_end_date))
      @subscription.active_status!
      payment.save!
    end

    if payment.persisted?
      render_ok SubscriptionRepresenter.new(@subscription).as_json, "Subscription successfully renewed"
    else
      errors = @subscription.errors.full_messages + payment.errors.full_messages
      render_unprocessable_entity "Failed to renew subscription or payment", errors
    end
  end

  def show_payments
    payments = @subscription.payments.order(:created_at).reverse_order.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
  end

  def destroy
    @subscription.destroy!
    head :no_content
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.expect(subscription: [ :start_date, :months ], payment: [ :payment_date, :amount, :payment_method, :transaction_id ])
  end
end

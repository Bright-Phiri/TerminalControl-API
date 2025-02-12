# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update destroy]

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

    months = params[:months].to_i
    end_date = start_date + months.months
    subscription = taxpayer.build_subscription(subscription_params[:subscription].merge(end_date: end_date))
    payment = subscription.payments.build(subscription_params[:payment])

    ActiveRecord::Base.transaction do
      subscription.save!
      payment.save!
    end

    if subscription.persisted? && payment.persisted?
       render_created SubscriptionRepresenter.new(subscription).as_json, "Subscription and payment successfully created"
    else
      errors = subscription.errors.full_messages + payment.errors.full_messages
      render_unprocessable_entity "Failed to create subscription or payment", errors
    end
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

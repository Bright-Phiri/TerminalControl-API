# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  load_and_authorize_resource only: %i[show renew show_payments destroy]

  def index
    subscriptions = Subscription.search(params[:search])
    subscriptions = subscriptions.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ subscriptions: SubscriptionsRepresenter.new(subscriptions).as_json, total: subscriptions.total_entries })
  end

  def show
    render_ok SubscriptionRepresenter.new(@subscription).as_json
  end

  def create
    taxpayer = Taxpayer.preload(:terminals).find(params[:taxpayer_id])
    raise ExceptionHandler::SubscriptionError if taxpayer.subscription.present?

    subscription_data, transaction_data = subscription_params

    service = SubscriptionService.new(
      taxpayer: taxpayer, subscription_data: subscription_data, payment_data: transaction_data
    )
    subscription, payment = service.create_subscription

    if subscription.persisted? && payment.persisted?
      log_subscription_action(subscription, payment, "create")
      render_created(SubscriptionRepresenter.new(subscription).as_json, "Subscription and payment successfully created")
    else
      errors = subscription.errors.full_messages + payment.errors.full_messages
      render_unprocessable_entity("Failed to create subscription or payment", errors)
    end
  end

  def renew
    @subscription = Subscription.find(params[:id])
    subscription_data, payment_data = subscription_params

    service = SubscriptionService.new(
      taxpayer: @subscription.taxpayer, subscription_data: subscription_data, payment_data: payment_data
    )
    payment = service.renew_subscription(@subscription)

    if payment.persisted?
      log_subscription_action(@subscription, payment, "renewed")
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

  def subscription_params
    subscription = params.require(:subscription).permit(:days)
    payment = params.require(:payment).permit(:payment_date, :amount, :payment_method, :transaction_id)
    [ subscription, payment ]
  end

  def log_subscription_action(subscription, payment, action)
    actions = SUBSCRIPTION_ACTIONS[action] || { subscription: "Unknown", payment: "Unknown" }

    Log.create!(
      user_id: logged_in_user.id,
      action: action,
      resource_type: subscription.class.name,
      resource_id: subscription.id,
      description: "#{actions[:subscription]} a subscription for taxpayer #{subscription.taxpayer.tin} from #{subscription.start_date} to #{subscription.end_date}."
    )

    Log.create!(
      user_id: logged_in_user.id,
      action: action,
      resource_type: payment.class.name,
      resource_id: payment.id,
      description: "#{actions[:payment]} a payment of MK #{payment.amount}."
    )
  end
end

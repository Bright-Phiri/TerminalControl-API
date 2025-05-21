# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show renew show_payments destroy]

  def index
    subscriptions =Subscription.search(params[:search])
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

    days = subscription_data[:days].to_i
    terminal_activation_date = DateTime.parse(taxpayer.terminals.first.activation_date).to_date
    start_date = terminal_activation_date
    end_date = start_date + days.days
    subscription = taxpayer.build_subscription(start_date: start_date, end_date: end_date)

    payment = nil

    ActiveRecord::Base.transaction do
      subscription.save!
      payment = subscription.payments.create!(transaction_data)
    end

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

    days = subscription_data[:days].to_i
    new_start_date = [ Time.current, @subscription.end_date ].max
    new_end_date = new_start_date + days.days

    payment = @subscription.payments.build(payment_data)
    sub_params = subscription_data.except(:days)
    ActiveRecord::Base.transaction do
      payment.save!
      @subscription.update!(sub_params.merge(start_date: new_start_date, end_date: new_end_date, expiry_notice_sent: false))
      @subscription.active_status!

      @subscription.taxpayer.terminals.find_each do |terminal|
        terminal.update!(status: :active)
      end
    end
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

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

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

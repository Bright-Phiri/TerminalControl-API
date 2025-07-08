# frozen_string_literal: true

class SubscriptionService
  def initialize(taxpayer:, subscription_data:, payment_data:)
    @taxpayer = taxpayer
    @subscription_data = subscription_data
    @payment_data = payment_data
  end

  def create_subscription
    days = @subscription_data[:days].to_i
    terminal_activation_date = DateTime.parse(@taxpayer.terminals.first.activation_date).to_date
    start_date = terminal_activation_date
    end_date = start_date + days.days
    subscription = @taxpayer.build_subscription(start_date: start_date, end_date: end_date)

    payment = nil
    ActiveRecord::Base.transaction do
      subscription.save!
      payment = subscription.payments.create!(@payment_data)
    end

    [subscription, payment]
  end

  def renew_subscription(subscription)
    days = @subscription_data[:days].to_i
    new_start_date = [Time.current, subscription.end_date].max
    new_end_date = new_start_date + days.days

    payment = subscription.payments.build(@payment_data)
    sub_params = @subscription_data.except(:days)
    ActiveRecord::Base.transaction do
      payment.save!
      subscription.update!(sub_params.merge(start_date: new_start_date, end_date: new_end_date, expiry_notice_sent: false))
      subscription.active_status!
      subscription.taxpayer.terminals.find_each { |terminal| terminal.update!(status: :active) }
    end
    payment
  end
end
# frozen_string_literal: true

class SubscriptionExpiryMailerJob < ApplicationJob
  queue_as :mailers

  attr_reader :subscription

  after_perform :mark_notice_sent

  def perform(subscription_id)
    @subscription = Subscription.find(subscription_id)
    return if @subscription.nil?

    SubscriptionMailer.with(subscription: @subscription).subscription_about_to_expire.deliver_now!
  end

  private

  def mark_notice_sent
    subscription.update!(expiry_notice_sent: true) if subscription.present?
  end
end

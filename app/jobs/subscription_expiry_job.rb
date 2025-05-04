# frozen_string_literal: true

class SubscriptionExpiryJob < ApplicationJob
  queue_as :default
    EXPIRY_NOTICE_WINDOW = 10.days
    def perform
      # Find subscriptions that will expire in the next 10 days
      subscriptions = Subscription.where("end_date BETWEEN ? AND ?", Time.current, Time.current +  EXPIRY_NOTICE_WINDOW).where.not(status: Subscription.statuses[:expired])
      if subscriptions.blank?
        Rails.logger.info "[SubscriptionExpiryJob] No subscriptions expiring within #{EXPIRY_NOTICE_WINDOW.inspect}."
        return
      end

      subscriptions.find_each do |subscription|
        SubscriptionMailer.with(subscription: subscription).subscription_about_to_expire.deliver_later
      end
    end
end

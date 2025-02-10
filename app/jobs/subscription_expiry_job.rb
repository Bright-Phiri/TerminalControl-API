# frozen_string_literal: true

class SubscriptionExpiryJob < ApplicationJob
  queue_as :default

    def perform
      # Find subscriptions that will expire in the next 14 days
      subscriptions = Subscription.where("end_date BETWEEN ? AND ?", Time.current, Time.current + 14.days)
      subscriptions.find_each do |subscription|
        SubscriptionMailer.with(subscription: subscription).subscription_about_to_expire.deliver_later
      end
    end
end

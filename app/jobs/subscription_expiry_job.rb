# frozen_string_literal: true

class SubscriptionExpiryJob < ApplicationJob
  queue_as :default

  EXPIRY_NOTICE_WINDOW = 10.days

  def perform
    start_date = Date.current
    end_date = start_date + EXPIRY_NOTICE_WINDOW

    subscriptions = Subscription.where("end_date BETWEEN ? AND ?", start_date, end_date)
                                .where.not(status: Subscription.statuses[:expired])

    if subscriptions.blank?
      Rails.logger.info "[SubscriptionExpiryJob] No subscriptions expiring between #{start_date} and #{end_date}."
      return
    end

    subscriptions.find_each do |subscription|
      Rails.logger.info "[SubscriptionExpiryJob] Sending expiry notice for subscription ID #{subscription.id}, ends on #{subscription.end_date}."
      SubscriptionMailer.with(subscription: subscription).subscription_about_to_expire.deliver_later
    end
  end
end

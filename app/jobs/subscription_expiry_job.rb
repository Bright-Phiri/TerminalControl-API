# frozen_string_literal: true

class SubscriptionExpiryJob < ApplicationJob
  queue_as :default

  def perform
    start_date = Date.current
    end_date = start_date + EXPIRY_NOTICE_WINDOW

    subscriptions = Subscription.where("end_date BETWEEN ? AND ?", start_date, end_date)
                                .where(expiry_notice_sent: false)
                                .where.not(status: Subscription.statuses[:expired])

    if subscriptions.blank?
      Rails.logger.info "[SubscriptionExpiryJob] No subscriptions expiring between #{start_date} and #{end_date}."
      return
    end

    subscriptions.find_each do |subscription|
      Rails.logger.info "[SubscriptionExpiryJob] Queuing expiry notice for subscription ID #{subscription.id}, ends on #{subscription.end_date}."
      SubscriptionExpiryMailerJob.perform_later(subscription.id)
    end
  end
end

# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  def subscription_about_to_expire
    @subscription = params[:subscription]
    @taxpayer = @subscription.taxpayer
    @days_left = (@subscription.end_date - Date.current).to_i

    mail(to: @taxpayer.email_address, subject: "Reminder: Your subscription is expiring soon")
  end
end

# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  def subscription_about_to_expire
    @subscription = params[:subscription]
    @taxpayer = @subscription.taxpayer

    mail(to: @taxpayer.email_address, subject: "Reminder: Your subscription is expiring soon")
  end
end

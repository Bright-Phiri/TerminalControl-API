# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  def subscription_about_to_expire
    @subscription = params[:subscription]
    @taxpayer = subscription.taxpayer

    mail(to: @user.email, subject: "Your subscription is about to expire!")
  end
end

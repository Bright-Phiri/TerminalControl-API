# frozen_string_literal: true

class SubscriptionRepresenter
  def initialize(subscription)
    subscription = subscription
  end

  def as_json
    {
      id: subscription.id,
      owner: subscriptions.taxpayer.tin,
      taxpayer: subscriptions.taxpayer.name,
      start_date: subscriptions.start_date,
      end_state: subscriptions.end_date
    }
  end

  private

  attr_reader :subscription
end

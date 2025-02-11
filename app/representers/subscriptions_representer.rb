# frozen_string_literal: true

class SubscriptionsRepresenter
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def as_json
    subscriptions.map do |subscription|
      {
        id: subscription.id,
        owner: subscription.taxpayer.tin,
        taxpayer: subscription.taxpayer.name,
        start_date: subscription.start_date,
        end_state: subscription.end_date
      }
    end
  end

  private

  attr_reader :subscriptions
end

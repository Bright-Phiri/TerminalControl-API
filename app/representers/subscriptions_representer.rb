# frozen_string_literal: true

class SubscriptionsRepresenter
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def as_json
    subscriptions.map do |subscription|
      {
        id: subscription.id,
        owner: subscriptions.taxpayer.tin,
        taxpayer: subscriptions.taxpayer.name,
        start_date: subscriptions.start_date,
        end_state: subscriptions.end_date
      }
    end
  end

  private

  attr_reader :subscriptions
end

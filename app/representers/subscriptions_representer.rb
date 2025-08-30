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
        start_date: subscription.start_date.strftime("%B %d, %Y"),
        end_date: subscription.end_date.strftime("%B %d, %Y"),
        status: subscription.status,
        created_at: subscription.formatted_created_at
      }
    end
  end

  private

  attr_reader :subscriptions
end

# frozen_string_literal: true

class SubscriptionRepresenter
  def initialize(subscription)
    @subscription = subscription
  end

  def as_json
    {
      id: subscription.id,
      owner: subscription.taxpayer.tin,
      taxpayer: subscription.taxpayer.name,
      start_date: subscription.start_date,
      end_date: subscription.end_date,
      status: subscription.status,
      payments: PaymentsRepresenter.new(subscription.payments).as_json
    }
  end

  private

  attr_reader :subscription
end

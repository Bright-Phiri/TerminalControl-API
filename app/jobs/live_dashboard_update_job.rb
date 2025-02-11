# frozen_string_literal: true

class LiveDashboardUpdateJob < ApplicationJob
  queue_as :dashboard_updates

  def perform
    data = {
      total_clients: Taxpayer.count,
      total_subscriptions: Subscription.count,
      active_subscriptions: Subscription.active.count,
      total_terminals: Terminal.count,
      total_payments: Payment.sum(:amount)
    }

    ActionCable.server.broadcast("dashboard_channel", data)
  end
end

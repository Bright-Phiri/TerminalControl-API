# frozen_string_literal: true

class LiveDashboardUpdateJob < ApplicationJob
  queue_as :dashboard_updates

  def perform
    data = {
      total_clients: Taxpayer.count,
      total_subscriptions: Subscription.count,
      active_subscriptions: Subscription.active_status.count,
      total_terminals: Terminal.count,
      active_terminals: Terminal.active_status.count,
      total_payments: Payment.sum(:amount),
      daily_revenue: Payment.daily_revenue.sum(:amount),
      weekly_revenue: Payment.weekly_revenue.sum(:amount),
      monthly_revenue: Payment.monthly_revenue.sum(:amount),
      recent_payments: PaymentsRepresenter.new(Payment.order(payment_date: :desc).limit(7)).as_json,
      subscription_trends: Subscription.statistics,
      payment_trends: Payment.statistics
    }

    ActionCable.server.broadcast("dashboard_channel", data)
  end
end

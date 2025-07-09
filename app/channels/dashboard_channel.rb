# frozen_string_literal: true

class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  after_subscribe do
    LiveDashboardUpdateJob.perform_later
  end
end

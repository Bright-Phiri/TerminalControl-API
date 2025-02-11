# frozen_string_literal: true

class DashbaordChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashbaord_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  on_subscribe do
    LiveDashboardUpdateJob.perform_later
  end
end

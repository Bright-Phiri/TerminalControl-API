# frozen_string_literal: true

class LiveDashboardUpdateJob < ApplicationJob
  queue_as :dashboard_updates

  def perform(*args)
    # Do something later
  end
end

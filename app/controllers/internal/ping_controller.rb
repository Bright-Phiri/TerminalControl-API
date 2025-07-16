# frozen_string_literal: true

class Internal::PingController < ApplicationController
  skip_before_action :authorize_request

  def dashboard
    LiveDashboardUpdateJob.perform_later
    render_ok({ triggered_at: Time.zone.now })
  end
end

# frozen_string_literal: true

module LiveDashboardNotifiable
  extend ActiveSupport::Concern

  included do
    after_create_commit do
      LiveDashboardUpdateJob.perform_later
    end
  end
end

# config/initializers/mission_control_jobs.rb

Rails.application.config.to_prepare do
  if defined?(MissionControl::Jobs::ApplicationController)
    MissionControl::Jobs::ApplicationController.class_eval do
      skip_before_action :authorize_request
    end
  end
end

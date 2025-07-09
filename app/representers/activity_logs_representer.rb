# frozen_string_literal: true

class ActivityLogsRepresenter
  def initialize(logs)
    @logs = logs
  end

  def as_json
    logs.map do |activity|
      {
        user: activity.user.user_name,
        action: activity.action,
        resource_type: activity.resource_type,
        description: activity.description,
        created_at: activity.formatted_created_at
      }
    end
  end

  private

  attr_reader :logs
end

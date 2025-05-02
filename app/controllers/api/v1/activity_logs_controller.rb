# frozen_string_literal: true

class Api::V1::ActivityLogsController < ApplicationController
  skip_before_action :authorize_request

  def index
    logs = Log.search(params[:search])
    logs = logs.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ logs: ActivityLogsRepresenter.new(logs).as_json, total: logs.total_entries })
  end
end

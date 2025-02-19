# frozen_string_literal: true

class Api::V1::TerminalsController < ApplicationController
  before_action :set_terminal, only: :show
  skip_before_action :authorize_request, only: :check_terminal_status
  before_action :authenticate!, only: :check_terminal_status

  def index
    terminals = Terminal.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok({ terminals: TerminalsRepresenter.new(terminals).as_json, total: terminals.total_entries })
  end

  def show
    render_ok TerminalRepresenter.new(@terminal).as_json
  end

  def check_terminal_status
    @terminal = Terminal.find_by! terminal_id: params[:terminal_id]
    blocked = @terminal.active_status? ? false : true
    render_ok ({ blocked: blocked })
  end

  private

  def set_terminal
    @terminal = Terminal.find(params[:id])
  end

  def terminal_params
    params.expect([ :terminal_id ])
  end
end

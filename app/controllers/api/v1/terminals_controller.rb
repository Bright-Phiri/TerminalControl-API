# frozen_string_literal: true

class Api::V1::TerminalsController < ApplicationController
  before_action :set_terminal, only: %i[show]
  def index
    terminals = Terminal.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render json: { terminals:, total: terminals.total_entries }
  end

  def show
    render json: @terminal
  end

  private

  def set_terminal
    @terminal = Terminal.find(params[:id])
  end
end

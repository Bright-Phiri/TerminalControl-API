# frozen_string_literal: true

class Api::V1::TerminalsController < ApplicationController
  before_action :set_terminal, only: %i[show]
  def index
    terminals = Terminal.all
    render json: terminals
  end

  def show
    render json: @terminal
  end

  private

  def set_terminal
    @terminal = Terminal.find(params[:id])
  end
end

# frozen_string_literal: true

class Api::V1::TaxpayersController < ApplicationController
  def index
    taxpayers = Taxpayer.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render json: { taxpayers:, total: taxpayers.total_entries }
  end

  def show_terminals
    taxpayer = Taxpayer.find(params[:id])
    terminals = taxpayer.terminals.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render json: { terminals: TerminalsRepresenter.new(terminals).as_json, total: terminals.total_entries }
  end

  def show_payments
    taxpayer = Taxpayer.includes(:payments).find(params[:id])
    payments = taxpayer.payments.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render json: { payments:, total: payments.total_entries }
  end
end

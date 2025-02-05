# frozen_string_literal: true

class Api::V1::TaxpayersController < ApplicationController
  def index
    taxpayers = Taxpayer.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ taxpayers:, total: taxpayers.total_entries })
  end

  def show_terminals
    taxpayer = Taxpayer.find(params[:id])
    terminals = taxpayer.terminals.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ terminals: TerminalsRepresenter.new(terminals).as_json, total: terminals.total_entries })
  end

  def show_payments
    taxpayer = Taxpayer.includes(:payments).find(params[:id])
    payments = taxpayer.payments.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
  end
end

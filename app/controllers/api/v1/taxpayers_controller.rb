# frozen_string_literal: true

class Api::V1::TaxpayersController < ApplicationController
  before_action :set_taxpayer, only: %i[block_terminals]
  def index
    taxpayers = Taxpayer.all
    render json: taxpayers
  end

  def block_terminals
    @taxpayer.terminals.update_all(status: :blocked)
  end

  def show_terminals
    taxpayer = Taxpayer.preload(:terminals).find(params[:id])
    render json: taxpayer.terminals
  end

  def show_payments
    taxpayer = Taxpayer.preload(:payments).find(params[:id])
    render json: taxpayer.payments
  end

  private

  def set_taxpayer
    @taxpayer = Taxpayer.find(params[:id])
  end
end

# frozen_string_literal: true

class API::V1::TaxpayersController < ApplicationController
  def index
    taxpayers = Taxpayer.all
    render json: taxpayers
  end

  def create
  end

  def show_terminals
    taxpayer = Taxpayer.preload(:terminals).find(params[:id])
    render json: taxpayer.terminals
  end

  def show_payments
    taxpayer = Taxpayer.preload(:payments).find(params[:id])
    render json: taxpayer.payments
  end
end

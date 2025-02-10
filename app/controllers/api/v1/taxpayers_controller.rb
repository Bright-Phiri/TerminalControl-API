# frozen_string_literal: true

class Api::V1::TaxpayersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :authenticate!, only: :create

  def index
    taxpayers = Taxpayer.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ taxpayers:, total: taxpayers.total_entries })
  end

  def subscribe_taxpayer
    subscription_data = subscription_params
    taxpayer = Taxpayer.find_or_initialize_by(tin: subscription_data.dig(:taxpayer, :tin))

    if taxpayer.new_record? && !taxpayer.update(subscription_data[:taxpayer])
      return render_unprocessable_entity "Failed to create subscription", taxpayer.errors.full_messages
    end

    terminal = taxpayer.terminals.build(subscription_data[:terminal])

    if terminal.save
      render_created ( { taxpayer: taxpayer, terminal: terminal })
    else
      render_unprocessable_entity "Failed to create subscription", terminal.errors.full_messages
    end
  end

  def show_terminals
    taxpayer = Taxpayer.find(params[:id])
    terminals = taxpayer.terminals.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ terminals: TerminalsRepresenter.new(terminals).as_json, total: terminals.total_entries })
  end

  def show_payments
    taxpayer = Taxpayer.includes(:payments).find(params[:id])
    payments = taxpayer.payments.order(:created_at).reverse_order.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
  end

  private

  def subscription_params
    params.expect(subscription: [ taxpayer: [ :tin, :name, :email_address, :phone_number ], terminal: [ :terminal_id, :terminal_label, :activation_date ] ])
  end
end

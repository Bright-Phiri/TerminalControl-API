# frozen_string_literal: true

class Api::V1::TaxpayersController < ApplicationController
  skip_before_action :authorize_request, only: :subscribe_taxpayer
  before_action :authenticate!, only: :subscribe_taxpayer
  before_action :set_taxpayer, only: :show

  def index
    taxpayers = Taxpayer.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok ({ taxpayers:, total: taxpayers.total_entries })
  end

  def show
    render_ok @taxpayer
  end

  def subscribe_taxpayer
    subscription_data = subscription_params
    taxpayer = Taxpayer.find_or_initialize_by(tin: subscription_data.dig(:taxpayer, :tin))

    if taxpayer.new_record? && !taxpayer.update(subscription_data[:taxpayer])
      return render_unprocessable_entity "Failed to subscribe taxpayer", taxpayer.errors.full_messages
    end

    terminal = taxpayer.terminals.build(subscription_data[:terminal])

    if terminal.save
      render_created ( { taxpayer: taxpayer, terminal: terminal })
    else
      render_unprocessable_entity "Failed to subscribe taxpayer", terminal.errors.full_messages
    end
  end

  def show_terminals
    taxpayer = Taxpayer.find(params[:id])
    terminals = taxpayer.terminals.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ terminals: TerminalsRepresenter.new(terminals).as_json, total: terminals.total_entries })
  end

  def show_payments
    taxpayer = Taxpayer.find(params[:id])
    payments = Payment.joins(subscription: :taxpayer).where(subscriptions: { taxpayer_id: taxpayer.id }).order(created_at: :desc)
    .paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
  end

  def show_subscriptions
    taxpayer = Taxpayer.find(params[:id])
    subscriptions = taxpayer.subscriptions.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ subscriptions: SubscriptionsRepresenter.new(subscriptions).as_json, total: subscriptions.total_entries })
  end

  private

  def set_taxpayer
    @taxpayer = Taxpayer.find(params[:id])
  end

  def subscription_params
    params.expect(subscription: [ taxpayer: [ :tin, :name, :email_address, :phone_number ], terminal: [ :terminal_id, :terminal_label, :activation_date ] ])
  end
end

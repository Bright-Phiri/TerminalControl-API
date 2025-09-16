# frozen_string_literal: true

class Api::V1::TaxpayersController < ApplicationController
  skip_before_action :authorize_request, only: [ :subscribe_taxpayer, :login ]
  before_action :authenticate!, only: :subscribe_taxpayer
  before_action :set_taxpayer, only: [ :show, :show_terminals, :block_terminals, :unblock_terminals, :show_payments, :show_subscription  ]

  def index
    taxpayers = params[:search].present? ? Taxpayer.search(params[:search]) : Taxpayer.all
    taxpayers = taxpayers.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)
    render_ok({ taxpayers:, total: taxpayers.total_entries })
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
    terminals = @taxpayer.terminals

    terminals = terminals.search(params[:search]) if params[:search].present?
    terminals = terminals.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

    render_ok ({ terminals: TerminalsRepresenter.new(terminals).as_json, total: terminals.total_entries })
  end

  def block_terminals
    @taxpayer.terminals.update_all(status: :blocked)
    render_ok ({ message: "All terminals for taxpayer #{@taxpayer.tin} have been blocked." })
  end

  def unblock_terminals
    @taxpayer.terminals.update_all(status: :active)
    render_ok ({ message: "All terminals for taxpayer #{@taxpayer.tin} have been unblocked." })
  end

  def show_payments
    if @taxpayer.subscription.present?
      payments = @taxpayer.subscription.payments.order(:created_at).reverse_order.paginate(page: params[:page] || 1, per_page: params[:per_page] || 10)

      render_ok({ payments: PaymentsRepresenter.new(payments).as_json, total: payments.total_entries })
    else
      render_not_found "Subscription not found for taxpayer", nil
    end
  end

  def login
    if Taxpayer.exists?
      taxpayer = Taxpayer.find_by(tin: taxpayer_params[:tin].to_s)
      raise ExceptionHandler::InvalidTIN unless taxpayer.present?

      authenticate_taxpayer(taxpayer)
    else
      render_not_found "No taxpayer account found", nil
    end
  end

  def show_subscription
    subscription = @taxpayer.subscription
    if subscription.nil?
      render_not_found "Subscription not found for taxpayer", nil
    else
      render_ok SubscriptionRepresenter.new(subscription).as_json
    end
  end

  private

  def authenticate_taxpayer(taxpayer)
    raise ExceptionHandler::InvalidCredentials unless taxpayer.authenticate(taxpayer_params[:password])

    token = encode_token({ tin: taxpayer.tin, exp: TOKEN_EXPIRY_DURATION.from_now.to_i })
    render_ok({ taxpayer:, token: token, role: "Taxpayer" }, "Access granted")
  end

  def set_taxpayer
    @taxpayer = Taxpayer.find(params[:id])
  end

  def taxpayer_params
    params.permit(:tin, :password)
  end

  def subscription_params
    params.expect(subscription: [ taxpayer: [ :tin, :name, :email_address, :phone_number ], terminal: [ :terminal_id, :terminal_label, :activation_date ] ])
  end
end

# frozen_string_literal: true

class Api::V1::SubscriptionsController < ApplicationController
  skip_before_action :authorize_request
  before_action :authenticate!

  def create
    subscription_data = subscription_params
    taxpayer = Taxpayer.find_or_initialize_by(tin: subscription_data.dig(:taxpayer, :tin))

    if taxpayer.new_record? && !taxpayer.update(subscription_data[:taxpayer])
      return render json: { errors: taxpayer.errors.full_messages }, status: :unprocessable_entity
    end

    terminal = taxpayer.terminals.build(subscription_data[:terminal])

    if terminal.save
      render json: { taxpayer: taxpayer, terminal: terminal }, status: :created
    else
      render json: { errors: terminal.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def subscription_params
    params.expect(subscription: [ taxpayer: [ :tin, :name, :email_address, :phone_number ], terminal: [ :terminal_id, :terminal_label, :activation_date ] ])
  end
end

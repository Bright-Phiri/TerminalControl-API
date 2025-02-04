# frozen_string_literal: true

class BlockTaxpayerTerminalsJob < ApplicationJob
  queue_as :terminal_blocking

  def perform
    last_month = 1.month.ago.beginning_of_month..1.month.ago.end_of_month

    Taxpayer.joins(:terminals).where(terminals: { status: :active }).distinct.find_each do |taxpayer|
      unless taxpayer.payments.where(period: last_month).exists?
        taxpayer.terminals.active_status.update_all(status: :blocked)

        Rails.logger.info "Blocked terminals for taxpayer #{taxpayer.tin} due to missing payment"
      end
    end
  end
end

# frozen_string_literal: true

class BlockTaxpayerTerminalsJob < ApplicationJob
  queue_as :terminal_blocking

  def perform
    Subscription.where("end_date < ?", Time.current).find_each do |subscription|
      subscription.expired_status!
      subscription.taxpayer.terminals.active_status.update_all(status: :blocked)
    end
  end
end

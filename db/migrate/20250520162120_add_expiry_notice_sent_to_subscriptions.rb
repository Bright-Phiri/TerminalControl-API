class AddExpiryNoticeSentToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :subscriptions, :expiry_notice_sent, :boolean, default: false
  end
end

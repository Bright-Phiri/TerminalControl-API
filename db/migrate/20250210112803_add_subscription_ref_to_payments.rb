class AddSubscriptionRefToPayments < ActiveRecord::Migration[8.0]
  def change
    add_reference :payments, :subscription, null: false, foreign_key: true
  end
end

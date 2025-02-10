class RemoveTaxpayerFromPayments < ActiveRecord::Migration[8.0]
  def change
    remove_reference :payments, :taxpayer, null: false, foreign_key: true
  end
end

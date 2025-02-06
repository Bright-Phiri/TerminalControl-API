class AddTransactionIdToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :transaction_id, :string
  end
end

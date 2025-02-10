class RemovePeriodFromPayments < ActiveRecord::Migration[8.0]
  def change
    remove_column :payments, :period, :date
  end
end

class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.belongs_to :taxpayer, null: false, foreign_key: true
      t.date :period
      t.decimal :amount
      t.string :payment_method, null: false

      t.timestamps
    end
  end
end

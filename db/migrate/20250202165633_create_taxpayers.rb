class CreateTaxpayers < ActiveRecord::Migration[8.0]
  def change
    create_table :taxpayers do |t|
      t.string :tin, null: false
      t.string :name, null: false
      t.string :email_address, null: false
      t.string :phone_number, null: false
      t.integer :terminals_count

      t.timestamps
    end
  end
end

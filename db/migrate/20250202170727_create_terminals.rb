class CreateTerminals < ActiveRecord::Migration[8.0]
  def change
    create_table :terminals do |t|
      t.string :terminal_id, null: false
      t.string :terminal_label, null: false
      t.string :activation_date, null: false
      t.integer :status
      t.belongs_to :taxpayer, null: false, foreign_key: true

      t.timestamps
    end
  end
end

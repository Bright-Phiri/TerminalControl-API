class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :taxpayer, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :status

      t.timestamps
    end
  end
end

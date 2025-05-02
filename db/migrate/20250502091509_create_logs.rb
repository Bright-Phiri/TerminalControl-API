class CreateLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :logs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :action
      t.string :resource_type
      t.bigint :resource_id
      t.text :description
      t.datetime :performed_at

      t.timestamps
    end
  end
end

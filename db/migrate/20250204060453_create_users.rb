class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name, null: false
      t.string :role
      t.string :email_address, null: false
      t.string :phone_number
      t.string :password_digest

      t.timestamps
    end
  end
end

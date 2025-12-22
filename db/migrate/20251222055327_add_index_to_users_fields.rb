class AddIndexToUsersFields < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :user_name, unique: true
    add_index :users, :email_address, unique: true
    add_index :users, :reset_password_token
    add_index :users, :role
  end
end

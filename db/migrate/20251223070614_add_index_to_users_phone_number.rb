class AddIndexToUsersPhoneNumber < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :phone_number, unique: true
  end
end

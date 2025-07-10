class AddRoleToTaxpayers < ActiveRecord::Migration[8.0]
  def change
    add_column :taxpayers, :role, :string
  end
end

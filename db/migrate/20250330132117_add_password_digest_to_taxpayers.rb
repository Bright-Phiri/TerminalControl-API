class AddPasswordDigestToTaxpayers < ActiveRecord::Migration[8.0]
  def change
    add_column :taxpayers, :password_digest, :string
  end
end

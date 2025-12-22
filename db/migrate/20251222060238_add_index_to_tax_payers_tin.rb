class AddIndexToTaxPayersTin < ActiveRecord::Migration[8.0]
  def change
    add_index :taxpayers, :tin, unique: true
  end
end

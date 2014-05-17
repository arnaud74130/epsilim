class RemovePeriodeFromCharges < ActiveRecord::Migration
  def change
    remove_column :charges, :periode, :boolean
  end
end

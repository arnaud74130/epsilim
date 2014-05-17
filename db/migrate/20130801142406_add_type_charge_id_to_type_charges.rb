class AddTypeChargeIdToTypeCharges < ActiveRecord::Migration
  def change
    add_column :type_charges, :type_charge_id, :integer
  end
end

class CreateTypeChargeChantiers < ActiveRecord::Migration
  def change
    create_table :type_charge_chantiers do |t|
      t.integer :chantier_id
      t.integer :type_charge_id

      t.timestamps
    end
    add_index :type_charge_chantiers, :chantier_id
    add_index :type_charge_chantiers, :type_charge_id
  end
end

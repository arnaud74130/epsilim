class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer :chantier_id
      t.integer :type_charge_id
      t.boolean :previ
      t.date :reception
      t.integer :fournisseur_id
      t.string :nature
      t.date :paiement
      t.float :montant

      t.timestamps
    end
    add_index :charges, :chantier_id
    add_index :charges, :type_charge_id
    add_index :charges, :fournisseur_id
  end
end

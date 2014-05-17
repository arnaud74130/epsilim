class CreateRecettes < ActiveRecord::Migration
  def change
    create_table :recettes do |t|
      t.integer :chantier_id
      t.integer :type_financement_id
      t.string :nature
      t.date :reception
      t.float :montant
      t.boolean :previ

      t.timestamps
    end
  end
end

class CreateChantiers < ActiveRecord::Migration
  def change
    create_table :chantiers do |t|
      t.integer :numero
      t.string :code
      t.string :libelle
      t.string :statut
      t.date :debut
      t.date :fin

      t.timestamps
    end
  end
end

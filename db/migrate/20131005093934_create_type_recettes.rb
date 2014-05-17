class CreateTypeRecettes < ActiveRecord::Migration
  def change
    create_table :type_recettes do |t|
      t.string :nom
      t.integer :exercice_id
      t.integer :type_recette_id

      t.timestamps
    end
  end
end

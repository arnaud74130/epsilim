class AddChantierTrToTypeRecetteChantiers < ActiveRecord::Migration
  def change
    add_column :type_recette_chantiers, :chantier_id, :integer
    add_column :type_recette_chantiers, :type_recette_id, :integer
  end
end

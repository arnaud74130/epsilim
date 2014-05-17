class AddTypeRecetteToRecettes < ActiveRecord::Migration
  def change
    add_column :recettes, :type_recette_id, :integer
  end
end

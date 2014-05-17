class CreateTypeRecetteChantiers < ActiveRecord::Migration
  def change
    create_table :type_recette_chantiers do |t|

      t.timestamps
    end
  end
end

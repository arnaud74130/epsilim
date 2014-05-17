class AddExerciceToChantiers < ActiveRecord::Migration
  def change
    add_column :chantiers, :exercice_id, :integer
  end
end

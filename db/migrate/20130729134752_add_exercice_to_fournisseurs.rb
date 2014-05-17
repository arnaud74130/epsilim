class AddExerciceToFournisseurs < ActiveRecord::Migration
  def change
    add_column :fournisseurs, :exercice_id, :integer
  end
end

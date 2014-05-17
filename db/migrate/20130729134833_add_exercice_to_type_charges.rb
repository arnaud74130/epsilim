class AddExerciceToTypeCharges < ActiveRecord::Migration
  def change
    add_column :type_charges, :exercice_id, :integer
  end
end

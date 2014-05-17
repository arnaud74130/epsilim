class AddExerciceToTypeFinancements < ActiveRecord::Migration
  def change
    add_column :type_financements, :exercice_id, :integer
  end
end

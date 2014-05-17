class AddExerciceToPersonnes < ActiveRecord::Migration
  def change
    add_column :personnes, :exercice_id, :integer
  end
end

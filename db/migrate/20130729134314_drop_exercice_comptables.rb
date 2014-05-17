class DropExerciceComptables < ActiveRecord::Migration
  def change
  	drop_table :exercice_comptables
  end
end

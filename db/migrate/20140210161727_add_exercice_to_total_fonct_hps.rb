class AddExerciceToTotalFonctHps < ActiveRecord::Migration
  def change
    add_column :total_fonct_hps, :exercice_id, :integer
  end
end

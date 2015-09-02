class AddExerciceIdToPole < ActiveRecord::Migration
  def change
  	 add_column :poles, :exercice_id, :integer
  end
end
